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
APP_KEY=base64:+dtmA4HSsPJ1wsBGGVprNogYqyGw8qX+bavBtjzOgWA=

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

**Erro 500 (CRÍTICO - MÚLTIPLAS CORREÇÕES):**
- ✅ **APP_KEY atualizada:** A chave da aplicação foi gerada e configurada
- ✅ **LOG_CHANNEL corrigido:** Alterado de 'stderr' para 'errorlog' (específico Railway)
- ✅ **Permissões de storage:** Configuradas no docker-start.sh
- ✅ **Debug habilitado:** Logs detalhados para identificar problemas
- ⚠️ **Próximo passo:** Deploy e verificação dos logs no Railway

**Assets não carregam:**
- Verificar se `APP_URL` e `ASSET_URL` estão corretos
- Confirmar se o build foi executado corretamente
- Verificar logs do Railway

**Erro de banco de dados:**
- Verificar variáveis de ambiente do MySQL
- Confirmar se o serviço MySQL está ativo no Railway

**Debug Avançado no Railway:**
1. **Verificar logs de deploy:**
   - Acesse o painel do Railway
   - Vá em "Deployments" > "View Logs"
   - Procure por erros durante o build ou inicialização

2. **Verificar logs de runtime:**
   - Use `railway logs` no terminal
   - Ou acesse "Observability" > "Logs" no painel

3. **Variáveis de ambiente críticas:**
   ```
   APP_KEY=base64:+dtmA4HSsPJ1wsBGGVprNogYqyGw8qX+bavBtjzOgWA=
   LOG_CHANNEL=errorlog
   APP_ENV=production
   APP_DEBUG=false
   PORT=fornecida automaticamente pelo Railway
   ```

### Correção do Healthcheck

**Problema: "Service Unavailable" no Healthcheck**

**Causa Principal**: Incompatibilidade entre a imagem Docker e o comando de inicialização.

**Soluções aplicadas**:
1. **Correção do Dockerfile**: 
   - Alterado de `php:8.2-fpm-alpine` para `php:8.2-cli-alpine`
   - Removido script duplicado que estava sendo criado no build
   - Removida linha `EXPOSE 8000` (Railway gerencia automaticamente)

2. **Simplificação do docker-start.sh**: 
   - Removido o teste complexo de conexão MySQL que usava `mysqladmin`
   - Uso das variáveis corretas fornecidas pelo Railway
   - Substituído o loop de teste MySQL por um `sleep 10` simples

3. **Configuração do Railway**:
   - Timeout aumentado para 300 segundos no `railway.json`
   - Healthcheck configurado para path `/`

**Por que php:8.2-cli-alpine?**
- A imagem `fpm-alpine` é para uso com nginx/apache
- A imagem `cli-alpine` é compatível com `php artisan serve`
- O Railway espera que a aplicação responda diretamente na porta $PORT

**Verificação**:
Após o deploy, verifique:
- Logs mostram "🌐 Iniciando servidor na porta $PORT..."
- Healthcheck passa sem "service unavailable"
- Aplicação responde na URL do Railway

**Outros erros 500:**
- Verificar se todas as variáveis de ambiente estão definidas
- Confirmar se as migrações foram executadas
- Verificar logs de erro no Railway