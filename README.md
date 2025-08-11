# Password Manager - Gerenciador de Senhas

Um sistema web seguro para gerenciamento de credenciais desenvolvido em Laravel com autenticação, criptografia e gerador de senhas.

## 🌐 Demonstração Online

**🚀 [Acesse a aplicação em produção](https://passwordmanager-production.up.railway.app)**

*Aplicação hospedada no Railway para demonstração aos recrutadores*

## 🚀 Funcionalidades

- ✅ Sistema de autenticação completo (login/registro)
- ✅ Gerenciamento seguro de credenciais
- ✅ Gerador de senhas seguras com configurações personalizáveis
- ✅ Criptografia de senhas no banco de dados
- ✅ Interface moderna e responsiva com Tailwind CSS
- ✅ Validação de formulários
- ✅ Proteção CSRF

## 🛠️ Tecnologias Utilizadas

- **Backend:** Laravel 10.x
- **Frontend:** Blade Templates, Tailwind CSS, Vite
- **Banco de Dados:** MySQL
- **Autenticação:** Laravel Breeze
- **Criptografia:** Laravel Encryption

## 📋 Pré-requisitos

Antes de executar o projeto, certifique-se de ter instalado:

- PHP >= 8.1
- Composer
- Node.js >= 16.x
- NPM ou Yarn
- MySQL >= 5.7
- Git

## 🔧 Instalação e Configuração

### 1. Clone o repositório
```bash
git clone <url-do-repositorio>
cd PasswordManager
```

### 2. Instale as dependências do PHP
```bash
composer install
```

### 3. Instale as dependências do Node.js
```bash
npm install
```

### 4. Configure o ambiente
```bash
# Copie o arquivo de exemplo
cp .env.example .env

# Gere a chave da aplicação
php artisan key:generate
```

### 5. Configure o banco de dados
Edite o arquivo `.env` com suas configurações de banco:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=password_manager
DB_USERNAME=seu_usuario
DB_PASSWORD=sua_senha
```

### 6. Crie o banco de dados
```sql
CREATE DATABASE password_manager;
```

### 7. Execute as migrações
```bash
php artisan migrate
```

### 8. Compile os assets
```bash
# Para desenvolvimento (necessário manter rodando)
npm run dev

# Para produção
npm run build
```

### 9. Inicie o servidor
```bash
php artisan serve
```

O projeto estará disponível em: `http://127.0.0.1:8000`

## 🎯 Como Usar

### 1. Registro/Login
- Acesse a aplicação e crie uma conta ou faça login
- Todos os dados são protegidos por autenticação

### 2. Gerenciar Credenciais
- **Criar:** Clique em "Nova Credencial" no dashboard
- **Visualizar:** Veja todas suas credenciais na lista principal
- **Editar:** Clique no ícone de edição para modificar
- **Excluir:** Use o botão de exclusão (com confirmação)

### 3. Gerador de Senhas
- Na criação/edição de credenciais, use o botão "Gerar Senha"
- Ajuste o tamanho da senha (8-32 caracteres)
- A senha gerada inclui letras, números e símbolos especiais

## 🔒 Segurança

- **Criptografia:** Todas as senhas são criptografadas antes de serem salvas
- **Autenticação:** Sistema completo com proteção de rotas
- **CSRF Protection:** Proteção contra ataques CSRF
- **Validação:** Validação rigorosa de todos os inputs
- **Hash de Senhas:** Senhas de usuário com hash bcrypt

## 📁 Estrutura do Projeto

```
PasswordManager/
├── app/
│   ├── Http/Controllers/
│   │   └── CredencialController.php    # Controlador principal
│   └── Models/
│       └── Credencial.php              # Model das credenciais
├── database/
│   └── migrations/
│       └── create_credenciais_table.php # Estrutura do banco
├── resources/
│   └── views/
│       ├── credenciais/                # Views das credenciais
│       └── layouts/                    # Layouts da aplicação
└── routes/
    └── web.php                         # Rotas da aplicação
```

## 🧪 Testando a Aplicação

### Funcionalidades para Testar:

1. **Autenticação**
   - Registro de novo usuário
   - Login/Logout
   - Proteção de rotas

2. **CRUD de Credenciais**
   - Criar nova credencial
   - Listar credenciais
   - Editar credencial existente
   - Excluir credencial

3. **Gerador de Senhas**
   - Gerar senha com diferentes tamanhos
   - Verificar complexidade da senha gerada
   - Aplicar senha gerada no formulário

4. **Segurança**
   - Tentar acessar rotas protegidas sem login
   - Verificar criptografia das senhas no banco
   - Testar proteção CSRF

## 🚨 Solução de Problemas

### Erro "could not find driver"
```bash
# Limpe o cache
php artisan config:clear
php artisan cache:clear

# Verifique se as extensões MySQL estão habilitadas no PHP
```

### Assets não carregam
```bash
# Compile os assets novamente
npm run dev
# ou
npm run build
```

### Problemas de permissão
```bash
# No Linux/Mac
sudo chmod -R 775 storage bootstrap/cache

# No Windows, execute como administrador
```

## ⚠️ Importante para Execução

**Para que a aplicação funcione completamente, é necessário:**

1. **Manter o servidor Laravel rodando:**
   ```bash
   php artisan serve
   ```

2. **Manter o Vite rodando (para assets):**
   ```bash
   npm run dev
   ```

3. **Ou compilar os assets para produção:**
   ```bash
   npm run build
   ```

**Sem o Vite rodando ou assets compilados, o CSS e JavaScript não funcionarão corretamente.**

## 🚀 Deploy no Railway

### Pré-requisitos para Deploy
1. Conta no [Railway](https://railway.app)
2. Repositório Git (GitHub, GitLab, etc.)
3. Código commitado e enviado para o repositório

### Passos para Deploy

1. **Conecte seu repositório ao Railway:**
   - Acesse [Railway](https://railway.app)
   - Clique em "New Project"
   - Selecione "Deploy from GitHub repo"
   - Escolha este repositório

2. **Configure as variáveis de ambiente:**
   ```env
   APP_NAME="Password Manager"
   APP_ENV=production
   APP_KEY=base64:sua_chave_aqui
   APP_DEBUG=false
   APP_URL=https://seu-app.up.railway.app
   
   DB_CONNECTION=mysql
   DB_HOST=${{MYSQL_HOST}}
   DB_PORT=${{MYSQL_PORT}}
   DB_DATABASE=${{MYSQL_DATABASE}}
   DB_USERNAME=${{MYSQL_USER}}
   DB_PASSWORD=${{MYSQL_PASSWORD}}
   
   SESSION_DRIVER=database
   CACHE_DRIVER=database
   ```

3. **Adicione o banco MySQL:**
   - No painel do Railway, clique em "+ New"
   - Selecione "Database" → "Add MySQL"
   - As variáveis de ambiente serão criadas automaticamente

4. **Configure o build (criar arquivo `railway.toml`):**
   ```toml
   [build]
   builder = "nixpacks"
   
   [deploy]
   startCommand = "php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=$PORT"
   ```

5. **Comandos pós-deploy:**
   ```bash
   php artisan key:generate --force
   php artisan migrate --force
   php artisan config:cache
   php artisan route:cache
   php artisan view:cache
   ```

### Configurações Importantes

- **Domínio personalizado:** Configure em Settings → Domains
- **Variáveis de ambiente:** Adicione todas as variáveis necessárias
- **SSL:** Habilitado automaticamente pelo Railway

## 📝 Notas para Recrutadores

### 🎯 Acesso Rápido
**[👉 Clique aqui para testar a aplicação](https://passwordmanager-production.up.railway.app)**

### 🔍 O que este projeto demonstra:

- **Conhecimento em Laravel:** Uso de migrations, models, controllers, middleware
- **Segurança:** Implementação de criptografia, autenticação e proteções
- **Frontend:** Interface moderna e responsiva com Tailwind CSS
- **Boas Práticas:** Código limpo, estrutura organizada, validações
- **Deploy:** Aplicação em produção com banco de dados
- **Funcionalidades Completas:** CRUD completo com recursos avançados

### 🧪 Como Testar
1. **Acesse a aplicação online** (link acima)
2. **Registre uma conta** ou use credenciais de teste
3. **Teste todas as funcionalidades:**
   - Criar credenciais
   - Gerar senhas seguras
   - Editar e excluir credenciais
   - Verificar segurança e validações

### 📁 Principais Arquivos para Análise
- `app/Http/Controllers/CredencialController.php` - Lógica principal do CRUD
- `app/Models/Credencial.php` - Model com criptografia automática
- `resources/views/credenciais/` - Interface do usuário
- `database/migrations/` - Estrutura do banco de dados
- `routes/web.php` - Definição de rotas e middleware

### 🔒 Recursos de Segurança Implementados
- Criptografia automática de senhas
- Autenticação com Laravel Breeze
- Proteção CSRF em todos os formulários
- Validação rigorosa de inputs
- Autorização por usuário (cada usuário vê apenas suas credenciais)
- Hash seguro de senhas de usuário

### 💡 Diferenciais Técnicos
- Gerador de senhas seguras com JavaScript
- Interface responsiva e moderna
- Código limpo e bem documentado
- Aplicação deployada e funcional
- Estrutura escalável e manutenível

---

**Desenvolvido para demonstrar competências em desenvolvimento web seguro e boas práticas de programação.**
