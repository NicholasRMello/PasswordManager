# 🚀 Migração para DigitalOcean App Platform

## Por que DigitalOcean?

✅ **Mais confiável** que Railway para Laravel  
✅ **Deploy simples** direto do GitHub  
✅ **Banco MySQL gratuito** incluído  
✅ **Sem problemas de healthcheck**  
✅ **Preços transparentes** e justos  
✅ **Suporte brasileiro** e servidores locais  

## 📋 Pré-requisitos

1. Conta no [DigitalOcean](https://digitalocean.com)
2. Repositório no GitHub
3. Código commitado e enviado para o GitHub

## 🛠️ Arquivos Criados para Migração

### 1. `.do/app.yaml` - Configuração principal
- Define a aplicação Laravel
- Configura banco MySQL
- Variáveis de ambiente
- Healthcheck em `/health`

### 2. `build.sh` - Script de build
- Instala dependências PHP e Node.js
- Compila assets
- Otimiza aplicação

### 3. `start.do.sh` - Script de inicialização
- Executa migrações
- Inicia servidor Laravel

### 4. `.env.digitalocean` - Template de variáveis
- Todas as variáveis necessárias
- Pronto para configurar no painel

## 🚀 Passos para Deploy

### 1. Preparar o Repositório
```bash
# Fazer commit dos arquivos de configuração
git add .
git commit -m "Add: Configuração para DigitalOcean App Platform"
git push
```

### 2. Criar App no DigitalOcean
1. Acesse [DigitalOcean App Platform](https://cloud.digitalocean.com/apps)
2. Clique em **"Create App"**
3. Conecte seu repositório GitHub
4. Selecione o repositório `PasswordManager`
5. Escolha a branch `main`

### 3. Configurar a Aplicação
1. **Tipo**: Web Service
2. **Source Directory**: `/` (raiz)
3. **Build Command**: `./build.sh`
4. **Run Command**: `./start.do.sh`
5. **Port**: `8080` (padrão)

### 4. Configurar Banco de Dados
1. Adicione um **Database Component**
2. Escolha **MySQL**
3. Nome: `db`
4. Versão: `8`

### 5. Configurar Variáveis de Ambiente
No painel do DigitalOcean, adicione:

```
APP_NAME=Password Manager
APP_ENV=production
APP_DEBUG=false
APP_KEY=[gerar nova chave]
APP_URL=[será fornecida após deploy]
LOG_CHANNEL=errorlog
DB_CONNECTION=mysql
```

**Importante**: As variáveis do banco (DB_HOST, DB_PORT, etc.) são configuradas automaticamente pelo DigitalOcean.

### 6. Deploy
1. Clique em **"Create Resources"**
2. Aguarde o build e deploy
3. Acesse a URL fornecida

## 🔧 Configurações Importantes

### Gerar APP_KEY
Após o primeiro deploy, execute no console do DigitalOcean:
```bash
php artisan key:generate --show
```
Copie a chave e adicione nas variáveis de ambiente.

### Healthcheck
O endpoint `/health` já está configurado e funcionando.

### Migrações
As migrações são executadas automaticamente no `start.do.sh`.

## 💰 Custos Estimados

- **Web Service (Basic)**: ~$5/mês
- **MySQL Database (Basic)**: ~$15/mês
- **Total**: ~$20/mês

**Muito mais barato e confiável que Railway!**

## 🆘 Troubleshooting

### Build falha
- Verifique se `composer.json` e `package.json` estão corretos
- Confirme que os scripts têm permissão de execução

### App não inicia
- Verifique as variáveis de ambiente
- Confirme que `APP_KEY` está definida
- Verifique logs no painel do DigitalOcean

### Banco não conecta
- As variáveis do banco são automáticas
- Aguarde alguns minutos após o deploy
- Verifique se o banco foi criado corretamente

## 🎉 Vantagens sobre Railway

✅ **Deploy mais estável**  
✅ **Sem problemas de healthcheck**  
✅ **Banco incluído no preço**  
✅ **Melhor documentação**  
✅ **Suporte mais responsivo**  
✅ **Interface mais intuitiva**  

---

**Pronto para migrar? Siga os passos acima e tenha sua aplicação rodando sem dores de cabeça!** 🚀