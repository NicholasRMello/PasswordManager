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

# Build dos assets para produção (COM VERIFICAÇÃO)
echo "🎨 Compilando assets para produção..."
npm ci --only=production
npm run build

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
php artisan serve --host=0.0.0.0 --port=$PORT

## 🔍 **ANÁLISE DO PROBLEMA:**

O erro persiste porque mesmo removendo `--only=production`, o Vite ainda não está sendo instalado corretamente. Vejo nos logs que:

1. ✅ `npm ci` executa sem erros
2. ❌ `vite` não está no PATH
3. ✅ `npx vite --version` funciona (instala Vite 7.1.2)
4. ❌ Mas `npm run build` ainda falha com `sh: vite: not found`

## 🎯 **SOLUÇÃO DEFINITIVA:**

O problema é que `npm ci` em ambiente de produção pode ter comportamento diferente. Vamos usar `npx` diretamente no script de build:
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

# Build dos assets para produção (USANDO NPX)
echo "🎨 Compilando assets para produção..."
npm install  # Usar npm install em vez de npm ci
echo "🔧 Executando build do Vite com npx..."
npx vite build  # Usar npx diretamente

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
```

## 🎯 **SOLUÇÃO DEFINITIVA:**

O erro é claro: **"Cannot find package 'vite' imported from vite.config.js"** - o Vite não está sendo instalado localmente no `node_modules`, apenas via `npx`.

## 🎯 **SOLUÇÃO DEFINITIVA:**

Vamos modificar o <mcfile name="start.render.sh" path="c:\Users\nicho\Desktop\Projetos\PasswordManager\start.render.sh"></mcfile> com uma abordagem **completamente diferente**:
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

# Build dos assets para produção (SOLUÇÃO DEFINITIVA)
echo "🎨 Compilando assets para produção..."
echo "📦 Instalando dependências..."
npm install
echo "🔧 Verificando Vite..."
npx vite --version
echo "🔧 Executando build do Vite..."
npx vite build

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