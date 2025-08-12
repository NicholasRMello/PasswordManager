#!/bin/bash

# Aguardar um pouco para o MySQL estar disponível
echo "🚀 Iniciando aplicação Laravel..."
echo "⏳ Aguardando MySQL inicializar..."
sleep 10
echo "✅ Prosseguindo com a inicialização..."

# Configurar variáveis de ambiente
export DB_CONNECTION=mysql
# Variáveis já definidas pelo Railway
export LOG_CHANNEL=errorlog
export APP_ENV=production
export APP_DEBUG=false
export ASSET_URL=

# Debug das variáveis
echo "🔍 Variáveis de ambiente:"
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
echo "DB_DATABASE: $DB_DATABASE"
echo "DB_USERNAME: $DB_USERNAME"

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
echo "🔧 Testando configuração da aplicação..."
php artisan --version
echo "APP_KEY: ${APP_KEY:0:20}..."
echo "DB_CONNECTION: $DB_CONNECTION"

# Testar conexão com banco
echo "📊 Testando conexão com banco de dados..."
php artisan migrate:status || echo "⚠️ Erro na conexão com banco"

# Iniciar servidor Laravel
echo "🌐 Iniciando servidor na porta $PORT..."
php artisan serve --host=0.0.0.0 --port=$PORT