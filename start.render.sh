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

# CORREÇÃO CRÍTICA: Configurar Vite corretamente
echo "🔧 Configurando Vite para produção..."

# Verificar se o build do Vite foi bem-sucedido
if [ -f "public/build/.vite/manifest.json" ]; then
    echo "✅ Build do Vite bem-sucedido!"
    echo "📋 Movendo manifest para local correto..."
    cp public/build/.vite/manifest.json public/build/manifest.json
    
    # CORREÇÃO ADICIONAL: Garantir que o Laravel encontre os assets
    echo "🎯 Configurando caminhos dos assets..."
    
    # Criar links simbólicos para garantir que os assets sejam encontrados
    ln -sf /opt/render/project/src/public/build/assets /opt/render/project/src/public/assets 2>/dev/null || true
    
    # Verificar se os arquivos CSS e JS existem
    echo "📁 Verificando arquivos compilados..."
    ls -la public/build/assets/
    
    echo "📄 Conteúdo do manifest:"
    cat public/build/manifest.json
else
    echo "❌ ERRO: Build do Vite falhou!"
    exit 1
fi

# CONFIGURAÇÃO ESPECIAL PARA PRODUÇÃO
echo "⚙️ Configurando Laravel para produção..."

# Forçar configuração do Vite
cat > config/vite.php << 'EOF'
<?php

return [
    'build_directory' => 'build',
    'manifest' => 'manifest.json',
    'hot_file' => public_path('hot'),
    'commands' => [
        'serve' => [
            'npm',
            'run',
            'dev',
        ],
        'build' => [
            'npm',
            'run',
            'build',
        ],
    ],
];
EOF

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

# TESTE FINAL: Verificar se os assets estão acessíveis
echo "🧪 Testando acesso aos assets..."
if [ -f "public/build/assets/app-*.css" ]; then
    echo "✅ CSS encontrado!"
else
    echo "❌ CSS não encontrado!"
fi

if [ -f "public/build/assets/app-*.js" ]; then
    echo "✅ JS encontrado!"
else
    echo "❌ JS não encontrado!"
fi

# Iniciar servidor Laravel na porta correta
echo "🌐 Iniciando servidor na porta $PORT..."
php artisan serve --host=0.0.0.0 --port=${PORT:-10000}