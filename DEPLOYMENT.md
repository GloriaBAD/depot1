# Déploiement CodeArena sur VM

## Configuration

L'application est configurée pour être déployée sur: **195.15.202.76**

## Prérequis sur la VM

1. Docker et Docker Compose installés
2. Ports ouverts:
   - Port 80 (HTTP)
   - Optionnel: Port 443 (HTTPS avec certificat SSL)

## Instructions de déploiement

### 1. Transférer les fichiers sur la VM

```bash
# Depuis votre machine locale
scp -r . user@195.15.202.76:/path/to/deployment/
```

### 2. Se connecter à la VM

```bash
ssh user@195.15.202.76
cd /path/to/deployment/
```

### 3. Construire et démarrer les conteneurs

```bash
# Construire l'image
docker-compose build

# Démarrer les services
docker-compose up -d

# Vérifier le statut
docker-compose ps
```

### 4. Vérifier les logs

```bash
# Logs du frontend
docker-compose logs -f frontend
```

### 5. Accéder à l'application

Ouvrez votre navigateur et accédez à:
- **http://195.15.202.76**

## Commandes utiles

```bash
# Redémarrer les services
docker-compose restart

# Arrêter les services
docker-compose down

# Mettre à jour après des modifications
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# Voir les conteneurs actifs
docker ps

# Nettoyer les images inutilisées
docker system prune -a
```

## Configuration HTTPS (Recommandé pour production)

Pour ajouter HTTPS avec Let's Encrypt:

1. Installer Certbot
```bash
sudo apt update
sudo apt install certbot
```

2. Obtenir un certificat SSL
```bash
sudo certbot certonly --standalone -d votre-domaine.com
```

3. Mettre à jour nginx.conf pour utiliser SSL

## Troubleshooting

### Le port 80 est déjà utilisé
```bash
# Voir quel processus utilise le port 80
sudo lsof -i :80
# Arrêter le processus ou changer le port dans compose.yml
```

### Problème de permissions Docker
```bash
# Ajouter votre utilisateur au groupe docker
sudo usermod -aG docker $USER
# Se déconnecter et reconnecter
```

### Erreur de build
```bash
# Nettoyer et rebuild
docker-compose down -v
docker system prune -a -f
docker-compose build --no-cache
docker-compose up -d
```

## Notes importantes

- L'application utilise Supabase pour:
  - Base de données (PostgreSQL)
  - Authentification
  - Temps réel (WebSockets)
  - Edge Functions (exécution de code)

- Aucune base de données locale n'est nécessaire
- Toutes les variables d'environnement Supabase sont déjà configurées
- Le conteneur redémarre automatiquement en cas de crash
