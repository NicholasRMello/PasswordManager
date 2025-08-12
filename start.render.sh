#!/bin/bash

# Script de inicialização para Render
echo "🚀 Iniciando Password Manager no Render..."

# Aguardar banco PostgreSQL
echo "⏳ Aguardando PostgreSQL..."
sleep 10

# Verificar variáveis de ambiente essenciais
echo "🔍 Verificando variáveis de ambiente..."
echo "DB_CONNECTION: $DB_CONNECTION"
echo "DB_HOST: $DB_HOST"
echo "DB_DATABASE: $DB_DATABASE"
echo "DB_USERNAME: $DB_USERNAME"
echo "PORT: $PORT"

# Verificar se APP_KEY existe, se não, gerar uma
if [ -z "$APP_KEY" ]; then
    echo "🔑 Gerando APP_KEY..."
    php artisan key:generate --force
fi

# Executar migrações
echo "📊 Executando migrações..."
php artisan migrate --force

# Build dos assets para produção
echo "🎨 Compilando assets para produção..."
npm run build

# Verificar aplicação
echo "🔧 Verificando aplicação..."
php artisan --version

# Testar conexão com banco
echo "🗄️ Testando conexão com banco..."
php artisan migrate:status

# Iniciar servidor Laravel
echo "🌐 Iniciando servidor na porta $PORT..."
php artisan serve --host=0.0.0.0 --port=$PORT