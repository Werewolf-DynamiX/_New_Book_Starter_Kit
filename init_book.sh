#!/bin/bash
echo "📖 Initializing New Book Project..."

# 1. Generate unique project ID
read -p "Enter Project ID (no spaces, e.g. space_opera_01): " PROJ_ID

# 2. Create .env file
echo "PROJECT_NAME=$PROJ_ID" > .env

# 3. Create Data Directories
mkdir -p backups

echo "✅ Setup Complete!"