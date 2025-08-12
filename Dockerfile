FROM php:8.2-cli-alpine

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
    postgresql-client \
    postgresql-dev \
    oniguruma-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libxpm-dev \
    bash

# Instalar extensões PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir diretório de trabalho
WORKDIR /var/www

# Copiar código
COPY . .

# Instalar dependências
RUN composer install --optimize-autoloader --no-dev
RUN npm install

# Build dos assets
ENV NODE_ENV=production
RUN npm run build

# Se o manifest estiver em .vite/, mover para o local correto
RUN if [ -f "public/build/.vite/manifest.json" ]; then \
        echo "Movendo manifest para local correto"; \
        cp public/build/.vite/manifest.json public/build/manifest.json; \
    fi

# Verificar se manifest está no local correto
RUN test -f public/build/manifest.json && echo "✅ Manifest OK" || (echo "❌ Manifest não encontrado" && exit 1)

# Permissões
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage \
    && chmod -R 755 /var/www/bootstrap/cache \
    && chmod -R 755 /var/www/public

# Usar a porta do ambiente (Render usa $PORT)
EXPOSE $PORT

# Script de inicialização
CMD php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache && \
    php artisan serve --host=0.0.0.0 --port=${PORT:-8000}