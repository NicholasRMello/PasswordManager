#!/bin/bash

# Aguardar o MySQL estar disponível
echo "Aguardando MySQL..."
while ! mysqladmin ping -h"$MYSQL_HOST" -P"$MYSQL_PORT" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    sleep 1
done
echo "MySQL está disponível!"

# Configurar variáveis de ambiente
export DB_CONNECTION=mysql
export DB_HOST=$MYSQL_HOST
export DB_PORT=$MYSQL_PORT
export DB_DATABASE=$MYSQL_DATABASE
export DB_USERNAME=$MYSQL_USER
export DB_PASSWORD=$MYSQL_PASSWORD
export APP_ENV=production
export APP_DEBUG=false

# Limpar caches
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

# Executar migrações se necessário
if [ "$RUN_MIGRATIONS" = "true" ]; then
    echo "Executando migrações..."
    php artisan migrate --force
fi

# Otimizar aplicação para produção
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Garantir que os assets estejam disponíveis
if [ ! -f "public/build/.vite/manifest.json" ]; then
    echo "Manifest não encontrado, executando build..."
    npm run build
fi

# Iniciar servidor Laravel
echo "Iniciando servidor Laravel na porta $PORT..."
php artisan serve --host=0.0.0.0 --port=$PORT