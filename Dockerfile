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
    oniguruma-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libxpm-dev

# Configurar extensão GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm

# Instalar extensões PHP
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd

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

# Definir variáveis de ambiente para o build
ENV NODE_ENV=production
ENV VITE_APP_NAME="Password Manager"

# Build dos assets para produção
RUN npm run build

# Verificar se os assets foram gerados
RUN ls -la public/build/ || echo "Build directory not found"

# Configurar permissões
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www/storage
RUN chmod -R 755 /var/www/bootstrap/cache
RUN chmod -R 755 /var/www/public
RUN mkdir -p /var/www/public/build && chmod -R 755 /var/www/public/build

# Tornar o script de inicialização executável
RUN chmod +x /var/www/docker-start.sh

# Expor porta
EXPOSE 8000

# Comando de inicialização
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]