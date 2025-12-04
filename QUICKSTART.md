# Guide de démarrage rapide - Déploiement sur VM

## Méthode 1: Déploiement automatique (Recommandé)

### Étape 1: Transférer les fichiers

```bash
./transfer-to-vm.sh user@195.15.202.76 /home/user/codearena
```

Remplacez `user` par votre nom d'utilisateur sur la VM.

### Étape 2: Se connecter à la VM et déployer

```bash
ssh user@195.15.202.76
cd /home/user/codearena
./deploy.sh
```

C'est tout ! L'application sera accessible sur **http://195.15.202.76**

---

## Méthode 2: Déploiement manuel

### Sur votre machine locale

1. Compresser le projet:
```bash
tar -czf codearena.tar.gz \
  --exclude='node_modules' \
  --exclude='.git' \
  --exclude='dist' \
  --exclude='build' \
  .
```

2. Transférer vers la VM:
```bash
scp codearena.tar.gz user@195.15.202.76:/home/user/
```

### Sur la VM

1. Se connecter:
```bash
ssh user@195.15.202.76
```

2. Extraire et déployer:
```bash
mkdir -p codearena
tar -xzf codearena.tar.gz -C codearena
cd codearena
./deploy.sh
```

---

## Vérification

1. Vérifier que les conteneurs tournent:
```bash
docker-compose ps
```

2. Voir les logs:
```bash
docker-compose logs -f
```

3. Tester l'application:
   - Ouvrez http://195.15.202.76 dans votre navigateur
   - Créez un compte
   - Testez les fonctionnalités

---

## Mise à jour de l'application

Après avoir fait des modifications:

1. Transférer les nouveaux fichiers:
```bash
./transfer-to-vm.sh user@195.15.202.76 /home/user/codearena
```

2. Sur la VM, reconstruire et redémarrer:
```bash
cd /home/user/codearena
./deploy.sh
```

---

## Résolution de problèmes

### Le port 80 est déjà utilisé

```bash
# Voir ce qui utilise le port 80
sudo lsof -i :80

# Arrêter le service (exemple avec Apache)
sudo systemctl stop apache2
```

### Permission denied avec Docker

```bash
# Ajouter votre user au groupe docker
sudo usermod -aG docker $USER

# Se déconnecter et reconnecter
exit
# Puis reconnexion SSH
```

### L'application ne se charge pas

1. Vérifier les logs:
```bash
docker-compose logs -f frontend
```

2. Vérifier le firewall:
```bash
# Ubuntu/Debian
sudo ufw status
sudo ufw allow 80/tcp

# CentOS/RHEL
sudo firewall-cmd --list-all
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --reload
```

3. Redémarrer les conteneurs:
```bash
docker-compose restart
```

---

## Configuration HTTPS (Production)

Pour sécuriser l'application avec HTTPS:

1. Obtenir un nom de domaine pointant vers 195.15.202.76

2. Installer Certbot:
```bash
sudo apt update
sudo apt install certbot python3-certbot-nginx
```

3. Obtenir un certificat:
```bash
sudo certbot --nginx -d votre-domaine.com
```

4. Le certificat se renouvelle automatiquement

---

## Support

Pour plus de détails, consultez:
- `DEPLOYMENT.md` - Documentation complète
- `compose.yml` - Configuration Docker
- Logs: `docker-compose logs -f`
