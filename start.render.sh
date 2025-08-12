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

# SOLUÇÃO DEFINITIVA: Instalar Vite globalmente e localmente
echo "🎨 Compilando assets para produção..."
echo "📦 Instalando dependências COMPLETAS..."

# Limpar cache do npm
npm cache clean --force

# Instalar TODAS as dependências (dev + prod)
NODE_ENV=development npm install

# Verificar se Vite foi instalado
echo "🔍 Verificando Vite instalado:"
npm list vite

# Se ainda não tiver Vite, instalar manualmente
if ! npm list vite > /dev/null 2>&1; then
    echo "⚠️ Vite não encontrado, instalando manualmente..."
    npm install vite@^5.0.0 --save-dev
fi

# Build com verificação
echo "🔧 Executando build do Vite..."
NODE_ENV=production npm run build

# Verificar se o manifest foi gerado
if [ ! -f "public/build/manifest.json" ]; then
    echo "❌ ERRO: Manifest do Vite não foi gerado!"
    echo "📁 Listando conteúdo de public/build:"
    ls -la public/build/ || echo "Pasta public/build não existe"
    echo "🔍 Verificando instalação do Vite:"
    npm list vite || echo "Vite não está nas dependências instaladas"
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
php artisan serve --host=0.0.0.0 --port=$PORT

## 🔧 **ALTERNATIVA MAIS RADICAL (se a primeira não funcionar):**

Se ainda der erro, vamos **remover completamente o Vite** e usar uma abordagem mais simples:
```bash
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

# SOLUÇÃO RADICAL: Build sem Vite
echo "🎨 Compilando assets SEM Vite..."
echo "📦 Instalando dependências básicas..."
npm install

# Criar manifest.json manualmente
echo "🔧 Criando manifest.json manualmente..."
mkdir -p public/build
echo '{"resources/css/app.css":{"file":"assets/app.css","isEntry":true},"resources/js/app.js":{"file":"assets/app.js","isEntry":true}}' > public/build/manifest.json

# Copiar assets básicos
cp resources/css/app.css public/build/assets/ 2>/dev/null || echo "CSS não encontrado"
cp resources/js/app.js public/build/assets/ 2>/dev/null || echo "JS não encontrado"

echo "✅ Assets preparados manualmente!"

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
php artisan serve --host=0.0.0.0 --port=$PORT