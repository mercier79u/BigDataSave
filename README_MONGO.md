Lien pour l'image : https://hub.docker.com/repository/docker/antoinemercier/mongo-api



Voici la classe produit :
```java
@Document(collection = "produit")
public class Produit implements Serializable {
    @Id
    private String id;

    @Field("designation")
    private String designation;

    @Field("prix")
    private double prix;

    public Produit(String id, String designation, double prix) {
        this.id = id;
        this.designation = designation;
        this.prix = prix;
    }

    public Produit() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public double getPrix() {
        return prix;
    }

    public void setPrix(double prix) {
        this.prix = prix;
    }
}
```

Voici le repository :
```java 
@Repository
public interface ProduitRepository extends MongoRepository<Produit, String> {
    Produit findByDesignation(String designation);
}

```

Voici le controlleur : 
```java
@RestController
@RequestMapping("/produit")
public class ProduitService  {

    private final ProduitRepository produitRepository;

    public ProduitService(ProduitRepository produitRepository) {
        this.produitRepository = produitRepository;
    }

    @GetMapping("/{desingation}/{prix}")
    public Produit add(@PathVariable String desingation, @PathVariable double prix)
    {
        if(!desingation.isEmpty())
        {
           return produitRepository.insert(new Produit(null, desingation, prix));
        }
        else
        {
            return null;
        }

    }

    @GetMapping("/{designation}")
    public Produit getById(@PathVariable String designation )
    {
        return produitRepository.findByDesignation(designation);
    }

}
```

Le docker file va nous permettre de créer l'image : 

```dockerfile
FROM openjdk:14
ADD bigdata-mongo.jar bigdata-mongo.jar
CMD ["java", "-jar", "bigdata-mongo.jar"]
expose 8080
```
On build d'abord l'image : 
<img source="dockerBuild.PNG">

Avant de la push sur le docker hub, ce qui va créer le repository par la même occasion :
<img source="dockerPush.PNG">

On lie ensuite la base à l'api grâce au fichier docker.compose.yml :
```yml
version: "3.8"
services:
  api-database:
    image: mongo
    container_name: "api-database"
    ports:
      - 27017:27017
  mongo-api:
    image: antoinemercier/mongo-api
    ports:
      - 9091:8080
    links:
      - api-database
```