# test 

## pré-requis

intaller packer, terraform

## configurer AWS

### Etape 1

* Avoir un compte AWS  
* Dans le service S3 bloquer tout les accès public (paramètres de compte)  
* Mettre region EU(londre)  
* Crer un compartiment  
	name:  mdsdalleau  
	region: UE (Londre)  
* Cliquer suivant  
	cocher: Chiffrer automatiquement les objets lorsqu'ils sont stockés dans S3  
* Cliquer suivant  
	cocher: Bloquer tout l'accès public  
* Cliquer suivant  
* Cliquer sur créer un compartiment  

### Etape 2
* Aller sur le service iam  
* Dans Utilisteurs  
* Ajouter un utilisateur  
	Choisir darlok  
	Cocher Accès par programmation  
* Attacher directement les strategies existantes  
	Cocher AdministratorAccess (1er)  
* Cliquer suivant  
* Cliquer suivant:balise  
* Cliquer suivant:verification  
* Puis créer récuperer vos identifiant secret et d'acces AWS  

### Etape 3
* cloner le projet `git clone https://github.com/darlok77/test.git`
* A la racine du projet lancé `packer build -var 'aws_access_key=YOUR_ACCES_KEY' -var 'aws_secret_key=YOUR_SECRET_KEY' packer.json` (remplacer par vos variable)
* cd live/eu-west-2/database  
* Lancé `terraform init `
* Dans la console AWS , dans le service EC2 ,AMI  récupérer l'id ami, amazon_pub et entrer les a la place de ami_id, et key_name (marquer par un ici en commentaire)
* Lancé `terraform apply ` 
~~ * cd live/eu-west-2/bastion ~~
~~ * Lancé `terraform init ` ~~
~~ * Dans la console AWS , dans le service EC2 ,AMI  récupérer l'id ami, amazon_pub et entrer les a la place de ami_id, et key_name (marquer par un ici en commentaire) ~~
~~ * Lancé `terraform apply ` ~~  

* Dans la console AWS aller dans service EC2
* Dans instance lancé une l'instance
* Selectionner mes AMI, selectionner votre ami créer
* Cliquer sur verifier et crer puis lancer
* Crer une paire de clef , la nommer et la telecharger pui lancer l'instance puis cliquer sur suivant  

* Appuyer sur votre machine en lancement copier l'adresse de la machine qui se trouve en bas DNS public (IPv4)
* `ssh-add YOUR_KEY` (remplasser par la clef telecharger précédemment lors de la creation de l'instance)
* `ssh ubuntu@YOUR-IP-SERVEUR` (remplasser par l'adresse de la machine copier précédemment)
* Sur cette console dans le home créer un dosier config avec a l'interieur un fichier config.json
* editer ce fichier et coller y cette config  
`{
  "server": {
    "host": "0.0.0.0",
    "port": "8080"
  },
  "options": {
    "prefix": "http://localhost:8080/"
  },
  "postgres": {
    "host": "terraform-20190523114702951900000001.cesdtpsfkos3.eu-west-2.rds.amazonaws.com",
    "port": "5432",
    "user": "toto",
    "password": "azertyuiop",
    "db": "ursho_db"
  }
}`
* lancé ursho
* ouvrer un autre console conecté aussi à cette instance
* tester ursho en executant `curl -H "Content-Type: application/json" -X POST -d '{"url":"www.google.com"}' http://YOUR_IP:8080/encode/` (remplacer YOUR_IP par le DNS public de votre intance copié précédemment )