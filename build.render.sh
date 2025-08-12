#!/bin/bash

# Script de build para Render
echo "🚀 Iniciando build para Render..."

# Instalar dependências PHP
echo "📦 Instalando dependências PHP..."
composer install --no-dev --optimize-autoloader

# Instalar dependências Node.js
echo "📦 Instalando dependências Node.js..."
npm install

# Compilar assets
echo "🔨 Compilando assets..."
npm run build

# Configurar permissões
echo "🔧 Configurando permissões..."
chmod -R 755 storage bootstrap/cache

# Limpar e otimizar caches
echo "🧹 Limpando caches..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

# Otimizar para produção
echo "⚡ Otimizando para produção..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "✅ Build concluído com sucesso!"