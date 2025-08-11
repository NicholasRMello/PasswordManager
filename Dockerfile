FROM php:8.2-fpm-alpine

# Instalar dependências do sistema
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm \
    mysql-client \
    oniguruma-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libxpm-dev

# Configurar extensão GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm

# Instalar extensões PHP
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir diretório de trabalho
WORKDIR /var/www

# Copiar arquivos do projeto
COPY . /var/www

# Instalar dependências PHP
RUN composer install --optimize-autoloader --no-dev

# Instalar dependências Node.js
RUN npm install
RUN npm run build

# Configurar permissões
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www/storage
RUN chmod -R 755 /var/www/bootstrap/cache

# Script de inicialização personalizado
RUN echo '#!/bin/sh' > /var/www/docker-start.sh && \
    echo 'echo "🚀 Iniciando aplicação Laravel..."' >> /var/www/docker-start.sh && \
    echo '' >> /var/www/docker-start.sh && \
    echo '# Aguardar um pouco para o MySQL estar disponível' >> /var/www/docker-start.sh && \
    echo 'echo "⏳ Aguardando MySQL inicializar..."' >> /var/www/docker-start.sh && \
    echo 'sleep 10' >> /var/www/docker-start.sh && \
    echo 'echo "✅ Prosseguindo com a inicialização..."' >> /var/www/docker-start.sh && \
    echo '' >> /var/www/docker-start.sh && \
    echo '# Configurar variáveis de ambiente' >> /var/www/docker-start.sh && \
    echo 'export DB_CONNECTION=mysql' >> /var/www/docker-start.sh && \
    echo '# Variáveis já definidas pelo Railway' >> /var/www/docker-start.sh && \
    echo 'export LOG_CHANNEL=stderr' >> /var/www/docker-start.sh && \
    echo 'export APP_DEBUG=true' >> /var/www/docker-start.sh && \
    echo '' >> /var/www/docker-start.sh && \
    echo '# Debug das variáveis' >> /var/www/docker-start.sh && \
    echo 'echo "🔍 Variáveis de ambiente:"' >> /var/www/docker-start.sh && \
    echo 'echo "DB_HOST: $DB_HOST"' >> /var/www/docker-start.sh && \
    echo 'echo "DB_PORT: $DB_PORT"' >> /var/www/docker-start.sh && \
    echo 'echo "DB_DATABASE: $DB_DATABASE"' >> /var/www/docker-start.sh && \
    echo 'echo "DB_USERNAME: $DB_USERNAME"' >> /var/www/docker-start.sh && \
    echo '' >> /var/www/docker-start.sh && \
    echo '# Limpar cache' >> /var/www/docker-start.sh && \
    echo 'php artisan config:clear' >> /var/www/docker-start.sh && \
    echo 'php artisan cache:clear' >> /var/www/docker-start.sh && \
    echo 'php artisan view:clear' >> /var/www/docker-start.sh && \
    echo '' >> /var/www/docker-start.sh && \
    echo '# Executar migrations' >> /var/www/docker-start.sh && \
    echo 'echo "📊 Executando migrations..."' >> /var/www/docker-start.sh && \
    echo 'php artisan migrate --force' >> /var/www/docker-start.sh && \
    echo '' >> /var/www/docker-start.sh && \
    echo '# Otimizar aplicação' >> /var/www/docker-start.sh && \
    echo 'php artisan config:cache' >> /var/www/docker-start.sh && \
    echo 'php artisan route:cache' >> /var/www/docker-start.sh && \
    echo 'php artisan view:cache' >> /var/www/docker-start.sh && \
    echo '' >> /var/www/docker-start.sh && \
    echo '# Iniciar servidor' >> /var/www/docker-start.sh && \
    echo 'echo "🌐 Iniciando servidor na porta $PORT..."' >> /var/www/docker-start.sh && \
    echo 'php artisan serve --host=0.0.0.0 --port=$PORT' >> /var/www/docker-start.sh && \
    chmod +x /var/www/docker-start.sh

# Expor porta
EXPOSE 8000

# Comando de inicialização
CMD ["/var/www/docker-start.sh"]