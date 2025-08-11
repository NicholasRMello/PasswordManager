#!/bin/bash

# Script de inicialização para Railway
# Este script garante que a aplicação seja iniciada corretamente

echo "🚀 Iniciando aplicação Laravel no Railway..."

# Copiar arquivo .env.production para .env
if [ -f ".env.production" ]; then
    echo "📄 Copiando .env.production para .env..."
    cp .env.production .env
fi

# Configurar variáveis de ambiente se não estiverem definidas
if [ -z "$DB_CONNECTION" ]; then
    export DB_CONNECTION="mysql"
fi

if [ -z "$LOG_CHANNEL" ]; then
    export LOG_CHANNEL="stderr"
fi

if [ -z "$APP_DEBUG" ]; then
    export APP_DEBUG="true"
fi

# Debug: Mostrar variáveis importantes
echo "📋 Variáveis de ambiente:"
echo "APP_ENV: $APP_ENV"
echo "APP_DEBUG: $APP_DEBUG"
echo "DB_CONNECTION: $DB_CONNECTION"
echo "LOG_CHANNEL: $LOG_CHANNEL"
echo "PORT: $PORT"
echo "DB_HOST: $DB_HOST"
echo "DB_DATABASE: $DB_DATABASE"

# Verificar se as variáveis de ambiente estão configuradas
if [ -z "$APP_KEY" ]; then
    echo "❌ Erro: APP_KEY não configurada"
    exit 1
fi

# Verificar permissões de diretórios
echo "🔐 Verificando permissões..."
chmod -R 755 storage
chmod -R 755 bootstrap/cache

# Verificar conexão com banco de dados (opcional)
if [ "$DB_CONNECTION" = "mysql" ]; then
    echo "📊 Verificando conexão com MySQL..."
    # Aguardar um pouco para o banco estar disponível
    sleep 5
fi

# Limpar cache de configuração
echo "🧹 Limpando cache..."
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear

# Otimizar para produção
echo "⚡ Otimizando para produção..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Executar migrations se necessário
if [ "$RUN_MIGRATIONS" = "true" ]; then
    echo "🗃️ Executando migrations..."
    php artisan migrate --force
    if [ $? -ne 0 ]; then
        echo "❌ Erro ao executar migrations"
        exit 1
    fi
fi

# Verificar se a aplicação está funcionando
echo "🔍 Testando configuração..."
php artisan config:show app.debug 2>/dev/null || echo "⚠️ Não foi possível verificar configuração"

# Verificar se o banco está acessível
echo "🗄️ Testando conexão com banco..."
php artisan migrate:status 2>/dev/null || echo "⚠️ Problema na conexão com banco"

# Iniciar servidor
echo "🌐 Iniciando servidor na porta $PORT..."
php artisan serve --host=0.0.0.0 --port=$PORT