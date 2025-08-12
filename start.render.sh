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

# COMPILAR ASSETS COM VITE CORRETAMENTE
echo "🎨 Compilando assets com Vite..."
echo "📦 Instalando dependências..."
npm install --include=dev

echo "🏗️ Compilando assets..."
NODE_ENV=production npm run build

# Verificar se o build do Vite foi bem-sucedido
if [ -f "public/build/.vite/manifest.json" ]; then
    echo "✅ Build do Vite bem-sucedido!"
    echo "📋 Movendo manifest para local correto..."
    cp public/build/.vite/manifest.json public/build/manifest.json
    echo "📄 Conteúdo do manifest:"
    cat public/build/manifest.json
else
    echo "❌ ERRO: Build do Vite falhou!"
    echo "📁 Criando fallback manual..."
    mkdir -p public/build/assets
    
    # Criar manifest.json manualmente como fallback
    cat > public/build/manifest.json << 'EOF'
{
  "resources/css/app.css": {
    "file": "assets/app.css",
    "isEntry": true,
    "src": "resources/css/app.css"
  },
  "resources/js/app.js": {
    "file": "assets/app.js",
    "isEntry": true,
    "src": "resources/js/app.js"
  }
}
EOF
    
    # Copiar assets básicos
    cp resources/css/app.css public/build/assets/app.css 2>/dev/null || echo "/* CSS básico */" > public/build/assets/app.css
    cp resources/js/app.js public/build/assets/app.js 2>/dev/null || echo "// JS básico" > public/build/assets/app.js
fi

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