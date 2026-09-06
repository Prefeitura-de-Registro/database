# Repositório de Banco de Dados (PostgreSQL)

Este repositório contém a infraestrutura em Docker para rodar o banco de dados localmente e o ORM Prisma para gerenciar o versionamento das tabelas. 

## Pré-requisitos
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado e rodando.
* Node.js e Git instalados.

## Configuração Inicial (Primeira vez)

1. Clone este repositório na sua máquina.
2. Abra o terminal na raiz do projeto e instale as dependências:
   ```bash
   npm install
   ```
3. Crie o seu arquivo de credenciais locais. Duplique o arquivo `.env.example`, renomeie a cópia para `.env` e mantenha o conteúdo padrão:
   ```env
   DATABASE_URL="postgresql://devuser:devpassword@localhost:5432/laboratoriodb?schema=public"
   ```
4. Ligue o motor do banco de dados em segundo plano:
   ```bash
   docker-compose up -d
   ```

---

## Fluxo de Trabalho do Desenvolvedor (Dia a dia)

Este é o roteiro exato que você deve seguir desde o momento em que o PO avisa que a tarefa (Issue) e a branch estão prontas. 

**O Cenário de Exemplo:** O PO criou a Issue `#12` pedindo a modelagem de usuários, gerou a branch `feat/12-tabelas-usuario` no GitHub e atribuiu a tarefa a você.

### Passo 1: Ligar o Banco e Atualizar o Git
Antes de qualquer coisa, garanta que o seu banco local está rodando e que o seu Git reconhece a nova branch criada pelo PO.
```bash
# Ligue o banco de dados no Docker
docker-compose up -d

# Atualize a lista de branches do seu computador
git fetch --all
```

### Passo 2: Entrar na branch da tarefa
Como o PO já criou a branch com a nomenclatura correta, você não usa o comando de criação (`-b`). Apenas entre na branch existente:
```bash
git checkout feat/12-tabelas-usuario
```

### Passo 3: Modelar, Versionar e Salvar
Toda a modelagem deve ser feita exclusivamente editando o arquivo `prisma/schema.prisma`.

1. Faça as alterações solicitadas na Issue dentro de `schema.prisma`.
2. Formate o arquivo para garantir que a pipeline (CI) do GitHub não bloqueie o seu código:
   ```bash
   npx prisma format
   ```
3. Para transformar seu código em tabelas reais no Docker e gerar o versionamento, execute:
   ```bash
   npx prisma migrate dev --name nome_da_sua_alteracao_aqui
   ```
   > **CRÍTICO:** O comando acima criará uma pasta chamada `prisma/migrations`. Você **deve** fazer o commit dessa pasta. É ela que garante que o banco da nuvem saberá quais tabelas criar. O arquivo `.env` será ignorado automaticamente.
4. Adicione tudo ao Git e faça o commit:
   ```bash
   git add .
   git commit -m "feat: cria modelagem e migration da tabela de usuarios"
   ```

### Passo 4: Enviar para o GitHub e Abrir o PR
Devolva o seu código finalizado para a branch que o PO criou no servidor.
```bash
git push origin feat/12-tabelas-usuario
```

**No site do GitHub:**
1. Clique no botão verde **Compare & pull request**.
2. Confirme se a seta está apontando para a branch principal de integração (ex: `base: develop` <- `compare: feat/12-tabelas-usuario`).
3. Na descrição, escreva `Closes #12` para fechar a issue automaticamente após a aprovação, e crie o PR.
---

## Visualizando os Dados (Opcional)
Para ver as tabelas e os dados salvos no seu banco local sem precisar instalar programas pesados como o pgAdmin, abra um terminal e rode:
```bash
npx prisma studio
```
Isso abrirá um painel administrativo no seu navegador (localhost:5555).