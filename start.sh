#!/bin/bash

# Script de inicialização para Railway
# Este script garante que a aplicação seja iniciada corretamente

echo "🚀 Iniciando aplicação Laravel no Railway..."

# Verificar se as variáveis de ambiente estão configuradas
if [ -z "$APP_KEY" ]; then
    echo "❌ Erro: APP_KEY não configurada"
    exit 1
fi

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
fi

# Iniciar servidor
echo "🌐 Iniciando servidor na porta $PORT..."
php artisan serve --host=0.0.0.0 --port=$PORT