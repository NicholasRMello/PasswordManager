#!/bin/bash

# Script de inicialização para Render
echo "🚀 Iniciando Password Manager no Render..."

# FORÇAR VARIÁVEIS DO RENDER (ignorar .env local)
echo "🔧 Configurando variáveis do Render..."
export DB_CONNECTION=pgsql
export DB_PORT=5432
export APP_ENV=production
export APP_DEBUG=false
export LOG_CHANNEL=errorlog
export CACHE_DRIVER=file
export SESSION_DRIVER=file
export QUEUE_CONNECTION=sync

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

# LIMPAR TODOS OS CACHES ANTES DE COMEÇAR
echo "🧹 Limpando caches..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

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
echo "📦 Instalando dependências..."
npm cache clean --force
NODE_ENV=development npm install

echo "🔧 Executando build do Vite..."
NODE_ENV=production npm run build

# Verificar se o manifest foi gerado
if [ ! -f "public/build/manifest.json" ]; then
    echo "❌ ERRO: Manifest do Vite não foi gerado!"
    echo "📁 Listando conteúdo de public/build:"
    ls -la public/build/ || echo "Pasta public/build não existe"
    exit 1
fi

echo "✅ Manifest do Vite encontrado!"

# Otimizações para produção
echo "⚡ Aplicando otimizações para produção..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize

# Verificar aplicação
echo "🔧 Verificando aplicação..."
php artisan --version

# Testar conexão com banco
echo "🗄️ Testando conexão com banco..."
php artisan migrate:status

# Iniciar servidor Laravel na porta correta
echo "🌐 Iniciando servidor na porta $PORT..."
php artisan serve --host=0.0.0.0 --port=${PORT:-10000}