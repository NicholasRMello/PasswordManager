#!/bin/bash

# Script de inicialização para DigitalOcean App Platform
echo "🚀 Iniciando Password Manager no DigitalOcean..."

# Aguardar um pouco para o banco estar disponível
echo "⏳ Aguardando banco de dados..."
sleep 5

# Executar migrações
echo "📊 Executando migrações..."
php artisan migrate --force

# Verificar se a aplicação está funcionando
echo "🔧 Verificando aplicação..."
php artisan --version

# Iniciar servidor Laravel
echo "🌐 Iniciando servidor na porta $PORT..."
php artisan serve --host=0.0.0.0 --port=$PORT