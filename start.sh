#!/bin/bash

echo "🚀 Iniciando aplicação Laravel (modo simples)..."

# Aguardar um pouco para garantir que tudo esteja pronto
echo "⏳ Aguardando inicialização..."
sleep 2

# Verificar se as migrations devem ser executadas
if [ "$RUN_MIGRATIONS" = "true" ]; then
    echo "📊 Executando migrations..."
    php artisan migrate --force
    if [ $? -eq 0 ]; then
        echo "✅ Migrations executadas com sucesso!"
    else
        echo "❌ Erro ao executar migrations!"
        exit 1
    fi
else
    echo "⏭️ Migrations desabilitadas (RUN_MIGRATIONS != true)"
fi

# Limpar e otimizar cache
echo "🧹 Limpando cache..."
php artisan config:clear
php artisan cache:clear
php artisan view:clear

echo "⚡ Otimizando aplicação..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Iniciar o servidor
echo "🌐 Iniciando servidor na porta ${PORT:-8000}..."
php artisan serve --host=0.0.0.0 --port=${PORT:-8000}