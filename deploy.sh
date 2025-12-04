#!/bin/bash

# Script de déploiement CodeArena
# Usage: ./deploy.sh

set -e

echo "=========================================="
echo "   Déploiement CodeArena"
echo "   IP: 195.15.202.76"
echo "=========================================="
echo ""

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker n'est pas installé${NC}"
    echo "Installez Docker: https://docs.docker.com/engine/install/"
    exit 1
fi

# Vérifier si Docker Compose est installé
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose n'est pas installé${NC}"
    echo "Installez Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo -e "${YELLOW}⏳ Arrêt des conteneurs existants...${NC}"
docker-compose down 2>/dev/null || true

echo -e "${YELLOW}⏳ Construction de l'image Docker...${NC}"
docker-compose build --no-cache

echo -e "${YELLOW}⏳ Démarrage des services...${NC}"
docker-compose up -d

echo ""
echo -e "${GREEN}✅ Déploiement réussi!${NC}"
echo ""
echo "=========================================="
echo "   Application disponible sur:"
echo "   http://195.15.202.76"
echo "=========================================="
echo ""
echo "Commandes utiles:"
echo "  - Voir les logs: docker-compose logs -f"
echo "  - Redémarrer: docker-compose restart"
echo "  - Arrêter: docker-compose down"
echo ""

# Afficher le statut des conteneurs
echo "Statut des conteneurs:"
docker-compose ps
