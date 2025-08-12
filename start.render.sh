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

## 🔍 ANÁLISE DOS LOGS:

1. **Vite está buildando**: `vite v5.4.19 building for production...`
2. **Mas não termina**: O build do Vite está sendo **interrompido**
3. **Manifest não é gerado**: Por isso `manifest.json` não existe
4. **Servidor não inicia**: "No open ports detected"

## ✅ SOLUÇÃO DEFINITIVA:

O problema é que o **build do Vite está falhando silenciosamente**. Vamos corrigir o script:
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
```