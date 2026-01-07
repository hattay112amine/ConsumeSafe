# ConsumeSafe - Application de Protection du Consommateur Tunisien

## 🎯 Vue d'ensemble

ConsumeSafe est une application web moderne conçue pour protéger les consommateurs tunisiens en :

✅ **Vérifier les produits boycottés** - Identifiez les produits à éviter  
🇹🇳 **Proposer des alternatives tunisiennes** - Découvrez des produits locaux de qualité  
📊 **Afficher les statistiques** - Suivez les tendances de boycott  
🌟 **Interface attrayante en tunisien** - Expérience utilisateur moderne et accessible  

## 🛠️ Stack Technologique

**Backend:**
- Java 17
- Spring Boot 3.2.0
- Spring Data JPA
- MySQL 8.0
- Maven 3.9

**Frontend:**
- HTML5
- CSS3 (Design moderne & responsive)
- JavaScript vanilla
- Arabe tunisien (RTL)

## 📋 Prérequis

- Java 17 ou supérieur
- MySQL 8.0 ou supérieur
- Maven 3.9 ou supérieur
- Un navigateur moderne

## 🚀 Installation et Configuration

### 1. Configuration de la Base de Données

```bash
mysql -u root -p
```

```sql
CREATE DATABASE IF NOT EXISTS consumesafe;
USE consumesafe;
```

### 2. Configuration de l'Application

Modifiez `src/main/resources/application.properties` :

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/consumesafe
spring.datasource.username=root
spring.datasource.password=votre_mot_de_passe
```

### 3. Compilation et Exécution

```bash
# Nettoyer et compiler
mvn clean compile

# Construire le JAR
mvn clean package

# Exécuter l'application
mvn spring-boot:run
```

L'application démarrera sur : **http://localhost:8082**

## 📡 Endpoints API

### Vérifier un Produit

```
GET /api/products/check?name=nom_du_produit
```

**Réponse:**
```json
{
  "productId": 1,
  "productName": "كوكا كولا",
  "brand": "Coca-Cola",
  "isBycotted": true,
  "boycottReason": "شركة تدعم الاحتلال الإسرائيلي",
  "status": "BOYCOTTED",
  "message": "⚠️ هذا المنتج قد يكون مدرجا في قائمة المقاطعة!",
  "suggestions": [
    {
      "productId": 5,
      "name": "عصير البرتقال التونسي",
      "brand": "الصفاقسي",
      "category": "المشروبات",
      "price": 2.0,
      "similarityScore": 0.85,
      "reason": "عصير تونسي بديل صحي"
    }
  ]
}
```

### Vérifier par Code-barre

```
GET /api/products/check-barcode?barcode=5449000000036
```

### Obtenir les Produits Tunisiens

```
GET /api/products/tunisian
```

### Obtenir les Produits Boycottés

```
GET /api/products/boycotted
```

### Rechercher des Produits

```
GET /api/products/search?query=terme_de_recherche
```

## 🎨 Fonctionnalités

### 1. Vérification en Temps Réel
- Recherche par nom de produit
- Recherche par code-barre
- Résultats instantanés

### 2. Suggérations Intelligentes
- Produits tunisiens alternatifs
- Score de similitude
- Informations détaillées

### 3. Interface Multilingue
- Interface en Arabe tunisien
- Support RTL complet
- Design responsive

### 4. Gestion des Données
- Base de données centralisée
- Mis à jour régulièrement
- Historique des boycotts

## 🗄️ Modèle de Données

### Entité Product
```
- id (Long) - Identifiant unique
- name (String) - Nom du produit
- description (String) - Description
- category (String) - Catégorie
- brand (String) - Marque
- barcode (String) - Code-barre
- boycotted (boolean) - Statut boycott
- boycottReason (String) - Raison du boycott
- tunisian (boolean) - Produit tunisien?
- imageUrl (String) - URL de l'image
- price (Double) - Prix
```

### Entité Alternative
```
- id (Long)
- boycottedProduct (Product) - Produit à éviter
- alternativeProduct (Product) - Produit alternatif
- reason (String) - Raison du remplacement
- similarityScore (Double) - Score de similitude
```

## 📊 Données Initiales

L'application charge automatiquement des données d'exemple au démarrage :

**Produits Boycottés:**
- Coca-Cola
- Nestlé (Nescafé)
- Starbucks

**Produits Tunisiens:**
- Café Halal Tunisien
- Jus Orange Sfaxien
- Dattes de Tunisie
- Harissa Traditionnelle
- Mloukhia du Sahel

## 🔧 Commandes Utiles

```bash
# Nettoyer
mvn clean

# Compiler
mvn compile

# Exécuter les tests
mvn test

# Construire le JAR
mvn package

# Exécuter le JAR
java -jar target/consumesafe-1.0.0.jar

# Exécuter avec logs détaillés
mvn spring-boot:run -X

# Vérifier les CVE
mvn org.owasp:dependency-check-maven:check
```

## 📱 Docker

### Construire l'image

```bash
docker build -t consumesafe:1.0.0 .
```

### Exécuter avec Docker Compose

```bash
docker-compose up -d
```

## 🐛 Dépannage

### Erreur: "Failed to determine a suitable driver class"
- Vérifiez que MySQL est en cours d'exécution
- Vérifiez la configuration `application.properties`
- Vérifiez que la base de données existe

### Erreur: "Could not find or load main class"
- Vérifiez que la classe principale est `com.exemple.App`
- Vérifiez `mainClass` dans `pom.xml`

### Port 8082 déjà utilisé
- Modifier le port dans `application.properties`
- Ou arrêter l'application qui utilise ce port

## 🤝 Contribution

Les contributions sont bienvenues ! Pour signaler un bug ou proposer une fonctionnalité :

1. Vérifiez les issues existantes
2. Créez une nouvelle issue descriptive
3. Soumettez un pull request avec vos changements

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

## 👥 Équipe

Développé avec ❤️ pour protéger les consommateurs tunisiens.

## 🙏 Remerciements

- Merci à la communauté tunisienne pour le soutien
- Merci à tous les contributeurs

---

**Version:** 1.0.0  
**Dernière mise à jour:** 7 Janvier 2026  
**Support:** support@consumesafe.tn

🛡️ **Protégez votre consommation. Soutenez le local. Votez avec votre panier!** 🛡️
