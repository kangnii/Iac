#!/bin/bash
# Stop le script si une commande échoue
set -e
echo "Initialisation de Tofu..."
tofu init
echo 
tofu plan
echo 
tofu apply -auto-approve
echo 