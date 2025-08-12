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

# Verificar se manifest foi criado
RUN test -f public/build/manifest.json && echo "✅ Manifest OK" || (echo "❌ Manifest não encontrado" && exit 1)

# Permissões
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage \
    && chmod -R 755 /var/www/bootstrap/cache \
    && chmod -R 755 /var/www/public

EXPOSE 8000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]