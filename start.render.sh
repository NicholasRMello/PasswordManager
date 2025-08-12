#!/bin/bash

echo "🚀 Iniciando Password Manager no Render..."

# Aguardar PostgreSQL
echo "⏳ Aguardando PostgreSQL..."
sleep 10

# Mostrar variáveis de ambiente
echo "🔍 Variáveis:"
echo "DB_CONNECTION=$DB_CONNECTION"
echo "DB_HOST=$DB_HOST"
echo "DB_DATABASE=$DB_DATABASE"
echo "DB_USERNAME=$DB_USERNAME"
echo "PORT=$PORT"

# Gerar APP_KEY se não existir
if [ -z "$APP_KEY" ]; then
    echo "🔑 Gerando APP_KEY..."
    php artisan key:generate --force
fi

# Executar migrações
echo "📊 Executando migrações..."
php artisan migrate --force

# Otimizações Laravel
echo "⚡ Otimizando aplicação..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize

# Subir servidor
echo "🌐 Iniciando servidor Laravel na porta $PORT..."
php artisan serve --host=0.0.0.0 --port=$PORT