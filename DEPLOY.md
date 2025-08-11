# Deploy no Railway - Password Manager

## Configurações Necessárias

### 1. Variáveis de Ambiente no Railway

Configure as seguintes variáveis de ambiente no painel do Railway:

```bash
# Aplicação
APP_NAME="Password Manager"
APP_ENV=production
APP_DEBUG=false
APP_URL=https://seu-dominio.up.railway.app
ASSET_URL=https://seu-dominio.up.railway.app
APP_KEY=base64:SUA_CHAVE_AQUI

# Banco de dados (Railway MySQL)
DB_CONNECTION=mysql
DB_HOST=${{MYSQL_HOST}}
DB_PORT=${{MYSQL_PORT}}
DB_DATABASE=${{MYSQL_DATABASE}}
DB_USERNAME=${{MYSQL_USER}}
DB_PASSWORD=${{MYSQL_PASSWORD}}

# Cache e Sessão
SESSION_DRIVER=database
CACHE_DRIVER=database
QUEUE_CONNECTION=database

# Logs
LOG_CHANNEL=stderr
LOG_LEVEL=info

# Build
NODE_ENV=production
VITE_APP_NAME="Password Manager"
RUN_MIGRATIONS=true
```

### 2. Comandos para Deploy

1. **Gerar nova chave da aplicação:**
   ```bash
   php artisan key:generate --show
   ```

2. **Build dos assets localmente (se necessário):**
   ```bash
   npm install
   npm run build
   ```

3. **Commit e push para o Railway:**
   ```bash
   git add .
   git commit -m "Deploy: Configurações de produção atualizadas"
   git push origin main
   ```

### 3. Verificações Pós-Deploy

- [ ] Verificar se os assets CSS/JS estão carregando corretamente
- [ ] Testar login e funcionalidades principais
- [ ] Verificar se o banco de dados está conectado
- [ ] Confirmar se as migrações foram executadas

### 4. Troubleshooting

**Assets não carregam:**
- Verificar se `APP_URL` e `ASSET_URL` estão corretos
- Confirmar se o build foi executado corretamente
- Verificar logs do Railway

**Erro de banco de dados:**
- Verificar variáveis de ambiente do MySQL
- Confirmar se o serviço MySQL está ativo no Railway

**Erro 500:**
- Verificar se `APP_KEY` está definida
- Confirmar se `APP_DEBUG=false` em produção
- Verificar logs de erro