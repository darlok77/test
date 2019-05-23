# test 
cd live/eu-west-2/database  
terraform init  
terraform apply  
set les clef secret et d'acces aws dans main.tf  
à la racine du projet packer packer.json  
dans la console aws aller dans service EC2  
dans instance a dans le menu a gauche lancé une l'instance  
selectionner mes AMI, selectionner votre ami créer  
cliquer sur verifier et crer puis lancer  
crer une paire de clef , la nommer et la telecharger pui lancer l'instance    
appuyer sur votre machine en lancement copier l'adresse de la machine qui se trouve en bas DNS public (IPv4)  
ssh-add YOUR_KEY (remplasser par la clef telecharger précédemment)  
ssh ubuntu@YOUR-IP-SERVEUR (remplasser par l'adresse de la machine copier précédemment)  
