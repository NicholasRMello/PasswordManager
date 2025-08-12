#!/bin/bash

# Script de build para DigitalOcean App Platform
echo "🚀 Iniciando build para DigitalOcean..."

# Instalar dependências do Composer
echo "📦 Instalando dependências PHP..."
composer install --no-dev --optimize-autoloader

# Instalar dependências do NPM e fazer build dos assets
echo "🎨 Compilando assets..."
npm ci
npm run build

# Configurar permissões
echo "🔧 Configurando permissões..."
chmod -R 775 storage
chmod -R 775 bootstrap/cache

# Limpar caches
echo "🧹 Limpando caches..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

# Otimizar para produção
echo "⚡ Otimizando aplicação..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "✅ Build concluído com sucesso!"