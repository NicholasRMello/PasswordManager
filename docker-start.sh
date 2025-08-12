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

# Configurar permissões de storage
chmod -R 775 storage
chmod -R 775 bootstrap/cache

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

# Verificar se a aplicação está funcionando
echo "Testando configuração da aplicação..."
php artisan --version
echo "APP_KEY: ${APP_KEY:0:20}..."
echo "DB_CONNECTION: $DB_CONNECTION"

# Testar conexão com banco
echo "Testando conexão com banco de dados..."
php artisan migrate:status || echo "Erro na conexão com banco"

# Iniciar servidor Laravel
echo "Iniciando servidor Laravel na porta $PORT..."
php artisan serve --host=0.0.0.0 --port=$PORT