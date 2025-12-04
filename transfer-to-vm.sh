#!/bin/bash

# Script de transfert vers la VM
# Usage: ./transfer-to-vm.sh user@195.15.202.76 /path/on/vm

set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 user@195.15.202.76 /path/on/vm"
    echo "Example: $0 ubuntu@195.15.202.76 /home/ubuntu/codearena"
    exit 1
fi

SSH_TARGET=$1
REMOTE_PATH=$2

echo "=========================================="
echo "   Transfert vers la VM"
echo "   Destination: $SSH_TARGET:$REMOTE_PATH"
echo "=========================================="
echo ""

# Créer le répertoire distant si nécessaire
echo "⏳ Création du répertoire distant..."
ssh $SSH_TARGET "mkdir -p $REMOTE_PATH"

# Transférer les fichiers
echo "⏳ Transfert des fichiers..."
rsync -avz --progress \
    --exclude 'node_modules' \
    --exclude '.git' \
    --exclude 'dist' \
    --exclude 'build' \
    --exclude '.env.local' \
    --exclude 'backend/node_modules' \
    --exclude 'frontend/node_modules' \
    --exclude 'sandbox' \
    . $SSH_TARGET:$REMOTE_PATH/

echo ""
echo "✅ Transfert terminé!"
echo ""
echo "Commandes suivantes:"
echo "  ssh $SSH_TARGET"
echo "  cd $REMOTE_PATH"
echo "  ./deploy.sh"
