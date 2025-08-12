#!/bin/bash
# Script de inicialização para Render

# Aguardar um pouco para o banco estar disponível
echo "⏳ Aguardando serviços..."
sleep 10

# Limpar caches
echo "🧹 Limpando caches..."
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear

# Instalar dependências
echo "📦 Instalando dependências..."
composer install --no-dev --optimize-autoloader

# Compilar assets
echo "🏗️ Compilando assets..."
npm ci
npm run build

# Verificar se o build do Vite foi bem-sucedido
if [ -f "public/build/.vite/manifest.json" ]; then
    echo "✅ Build do Vite bem-sucedido!"
    echo "📋 Movendo manifest para local correto..."
    cp public/build/.vite/manifest.json public/build/manifest.json
    
    echo "📄 Conteúdo do manifest:"
    cat public/build/manifest.json
    
    echo "📁 Verificando arquivos compilados..."
    ls -la public/build/assets/
else
    echo "❌ Falha no build do Vite! Usando fallback manual..."
    
    # Fallback manual
    mkdir -p public/build/assets
    
    # Criar manifest.json manual
    cat > public/build/manifest.json << 'EOF'
{
  "resources/css/app.css": {
    "file": "assets/app.css",
    "src": "resources/css/app.css",
    "isEntry": true
  },
  "resources/js/app.js": {
    "file": "assets/app.js",
    "name": "app",
    "src": "resources/js/app.js",
    "isEntry": true
  }
}
EOF
    
    # Copiar assets básicos
    cp resources/css/app.css public/build/assets/app.css 2>/dev/null || echo "CSS não encontrado"
    cp resources/js/app.js public/build/assets/app.js 2>/dev/null || echo "JS não encontrado"
fi

# Configurar Laravel para produção
echo "⚙️ Configurando Laravel para produção..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize

# Executar migrações (com retry em caso de falha temporária)
echo "🗄️ Executando migrações..."
for i in {1..3}; do
    if php artisan migrate --force; then
        echo "✅ Migrações executadas com sucesso!"
        break
    else
        echo "⚠️ Tentativa $i falhou, tentando novamente em 5s..."
        sleep 5
    fi
done

# Verificar aplicação
echo "🔧 Verificando aplicação..."
php artisan --version

# Testar conexão com banco
echo "🗄️ Testando conexão com banco..."
php artisan migrate:status

# Verificar se os assets estão acessíveis
echo "🧪 Testando acesso aos assets..."
if [ -f "public/build/assets/app-"*.css ]; then
    echo "✅ CSS encontrado!"
else
    echo "❌ CSS não encontrado!"
fi

if [ -f "public/build/assets/app-"*.js ]; then
    echo "✅ JS encontrado!"
else
    echo "❌ JS não encontrado!"
fi

# Iniciar servidor
echo "🌐 Iniciando servidor na porta 10000..."
php artisan serve --host=0.0.0.0 --port=10000