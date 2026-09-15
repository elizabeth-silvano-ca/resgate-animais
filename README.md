# 🐾 Resgate — cadastro de animais resgatados

Sistema simples para registrar animais resgatados: ficha completa, status de adoção,
fotos e anexo do termo de adoção assinado.

Roda 100% em ferramentas gratuitas:

| Peça | Ferramenta | Plano |
|---|---|---|
| Banco de dados, login e arquivos | [Supabase](https://supabase.com) | Grátis |
| Hospedagem do site | GitHub Pages ou [Netlify Drop](https://app.netlify.com/drop) | Grátis |

Não tem build, não tem servidor, não tem dependência instalada — é um `index.html` só.

---

## Já está no ar

O sistema está publicado e ligado a um banco de verdade:

- **Site:** https://resgate-animais-frada.netlify.app
- Endereço alternativo: https://elizabeth-silvano-ca.github.io/resgate-animais/
- **Projeto Supabase:** `resgate-animais`, organização `Resgate`, região São Paulo
- Auto-cadastro **desligado** — contas são criadas no painel do Supabase

O passo a passo abaixo fica como referência: para refazer a instalação do zero,
migrar para outra conta ou entender o que foi configurado.

---

## Publicando uma mudança

```bash
./publicar.sh "fix: descrição do que mudou"
```

Envia para o GitHub e para o Netlify, e carimba a versão. O carimbo é o que faz
quem está com o sistema aberto receber o aviso **"Há uma versão mais nova"**,
com um botão para recarregar — sem isso o navegador pode ficar minutos com a
versão antiga em cache.

---

## Só quer ver como é? (sem instalar nada)

Acrescente **`#demo`** no fim do endereço do site. (Numa instalação ainda sem
banco, a própria tela de login oferece o link **ver a demonstração**.)

O sistema abre com cinco animais de exemplo e funciona inteiro: cadastrar, anexar
fotos e termo, filtrar, buscar, o painel de castrações, exportar. Tudo roda dentro
do seu navegador — nada é enviado para lugar nenhum.

⚠️ Na demonstração **os dados existem só naquela aba e somem ao recarregar a página**.
Para valer, siga a instalação abaixo: é ela que cria o banco de verdade, com login
e dados compartilhados entre as pessoas.

---

## Arquivos

- **`index.html`** — o sistema inteiro (interface + lógica).
- **`supabase-schema.sql`** — cria a tabela, as permissões e o bucket de arquivos.
- **`publicar.sh`** — publica nos dois endereços e carimba a versão.
- **`README.md`** — este passo a passo.

---

## Instalação (uma vez, ~10 minutos)

### 1. Criar o projeto no Supabase

1. Entre em **supabase.com** e crie uma conta grátis.
2. **New project** → dê um nome (ex.: `resgate`), escolha uma senha de banco
   (guarde, mas você não vai precisar dela no dia a dia) e a região
   **South America (São Paulo)**.
3. Espere uns 2 minutos até o projeto ficar pronto.

### 2. Criar a estrutura do banco

1. No menu lateral, abra **SQL Editor** → **New query**.
2. Abra o arquivo `supabase-schema.sql`, copie **tudo** e cole ali.
3. Clique em **Run**. Deve aparecer *Success. No rows returned*.

Isso cria a tabela `animais`, as regras de acesso e o bucket privado `animais`
(onde ficam as fotos e os termos).

### 3. Fechar o auto-cadastro e criar as contas

O sistema **não tem tela de criar conta**: quem administra cria cada usuário
no painel do Supabase. Isso evita que qualquer pessoa com o link entre sozinha.

1. **Authentication** → **Sign In / Providers** → **Email** →
   desligue **Allow new users to sign up** e salve.
2. **Authentication** → **Users** → **Add user** → **Create new user**.
3. Preencha e-mail e senha e **marque Auto Confirm User** (senão a pessoa não
   consegue entrar até confirmar o e-mail, e o envio grátis é limitado a poucos
   e-mails por hora).
4. Repita para cada pessoa da equipe. Para tirar o acesso de alguém:
   **Users** → menu do usuário → **Delete user**.

Passe a senha para a pessoa por um canal seguro; ela usa o e-mail e a senha
direto na tela de login.

### 4. Pegar as chaves

1. **Project Settings** → **API Keys** (ou **Data API**).
2. Copie:
   - **Project URL** → algo como `https://abcdefgh.supabase.co`
   - **anon public** → um texto longo começando com `eyJ...`

> A chave `anon` é pública por natureza — ela pode ficar no site. Quem protege os
> dados são as regras de acesso (RLS) que o SQL criou: sem estar logado, ninguém lê nada.
> **Nunca** use a chave `service_role` aqui.

### 5. Publicar o site

**Opção A — Netlify Drop (mais rápido, sem conta):**
arraste a pasta `resgate-animais` inteira para [app.netlify.com/drop](https://app.netlify.com/drop).
Sai um link na hora. Crie uma conta grátis se quiser que o link seja permanente.

**Opção B — GitHub Pages:**

```bash
cd ~/PROJETOS/resgate-animais
git init && git add . && git commit -m "feat: sistema de cadastro de animais resgatados"
gh repo create resgate-animais --public --source=. --push
gh api -X POST repos/:owner/resgate-animais/pages -f build_type=legacy \
  -f 'source[branch]=main' -f 'source[path]=/'
```

O site fica em `https://SEU-USUARIO.github.io/resgate-animais/` em alguns minutos.

### 6. Conectar e dar acesso ao time

1. Abra o site publicado. Ele abre no **login**, avisando que falta o banco.
   Clique em **Configurar a conexão**, cole a **URL** e a **chave anon**, e conecte.
   (Para voltar a essa tela depois, acrescente `#configurar` no fim do endereço.)
2. Entre com a conta que você criou no passo 3.
3. Para cada pessoa: crie a conta no painel do Supabase (passo 3) e mande o link
   do botão **Convidar** — ele já vem com a conexão configurada, então a pessoa
   só precisa digitar e-mail e senha.

> **Deixe o site já nascendo conectado:** abra o `index.html`, ache
> `var EMBUTIDO = {` no início do script e preencha `url` e `key`. Depois publique
> de novo. Aí ninguém mais vê tela de configuração — só o login.

---

## Controlando quem entra

Não existe auto-cadastro: a tela inicial é só **login**, com e-mail e senha.
Toda conta nasce no painel do Supabase, pelas mãos de quem administra
(**Authentication → Users → Add user**, com *Auto Confirm User* marcado).

Ou seja: mesmo que o link do sistema vaze, ninguém entra sem uma conta que
você tenha criado. Para tirar o acesso de alguém, apague o usuário — o link
deixa de servir para essa pessoa na hora.

---

## O que dá para registrar

**Identificação** — nome, espécie, sexo, porte, idade aproximada, cor/pelagem, microchip.

**Resgate e saúde** — data e local do resgate, castrado, vacinado, condição de saúde, observações.

**Fotos** — quantas quiser, por animal. Dá para remover uma a uma na edição.

**Situação** — Disponível para adoção · Em tratamento · Adotado.

**Adoção** (aparece ao marcar *Adotado*) — nome, contato e documento do adotante,
data da adoção e o **termo de adoção assinado** em PDF ou foto.

Ainda tem busca por nome/local/adotante, filtro por status, contadores no topo
e **Exportar** (CSV que abre no Excel ou Google Planilhas).

---

## Painel de castrações pendentes

A aba **Castrações pendentes** é a primeira do sistema e já abre por padrão: junta
todo animal que ainda não está marcado como castrado e mostra quantos são no
contador ao lado do nome da aba. O botão **+ Novo animal** fica no topo, disponível
em qualquer aba; ao salvar, o sistema leva você para a lista de animais.

A lista vem separada em dois grupos:

- **Com adotante — avisar sobre a castração.** Traz nome e contato do adotante e um
  botão que abre a conversa direto: **Chamar no WhatsApp** (se o contato for telefone)
  ou **Enviar e-mail**. A mensagem já vai escrita com o nome do animal.
- **Ainda sob nossos cuidados — agendar castração.** Os que seguem no abrigo ou em
  lar temporário.

Dentro de cada grupo, a ordem é por urgência: quem **nunca foi avisado** aparece
primeiro, depois quem foi avisado há mais tempo.

Dois botões resolvem o dia a dia sem abrir a ficha:

- **Marcar como avisado** — anota a data de hoje. O selo vermelho *Nunca avisado*
  vira *Avisado hoje*, e depois *Avisado há N dias*, para você saber quem já está
  sendo cobrado demais e quem ficou esquecido.
- **Já castrado** — dá baixa: o animal sai do painel e o contador cai.

Se um adotado estiver sem telefone e sem e-mail, o painel avisa em vermelho —
é o sinal de que a ficha precisa ser completada.

> O telefone vira link de WhatsApp assumindo Brasil: o sistema tira a formatação e
> acrescenta o DDI **55** quando você digita só DDD + número. Sempre inclua o DDD.

---

## Privacidade dos arquivos

O bucket é **privado**. As fotos e os termos nunca ficam com link público: o
sistema gera um link temporário (1 hora) na hora de mostrar. Isso importa porque
o termo de adoção traz nome e documento do adotante.

---

## Limites do plano grátis do Supabase

- 500 MB de banco (dá para dezenas de milhares de fichas)
- 1 GB de arquivos (~1.000 fotos de celular comprimidas)
- 50.000 usuários

⚠️ **Projetos grátis pausam após ~1 semana sem nenhum acesso.** Se isso acontecer,
entre no painel do Supabase e clique em **Restore** — os dados não são perdidos.
Usar o sistema uma vez por semana já evita a pausa.

---

## Problemas comuns

| O que aparece | O que fazer |
|---|---|
| "A tabela 'animais' não existe" | O SQL não rodou. Refaça o passo 2. |
| "O bucket 'animais' não existe" | Idem — o passo 2 cria as duas coisas juntas. |
| "Falta uma coluna no banco" | Rode o `supabase-schema.sql` de novo; ele atualiza tabelas que já existem sem apagar dados. |
| "Confirme o e-mail antes de entrar" | Ao criar o usuário no Supabase, marque **Auto Confirm User**. |
| "Esse e-mail não tem conta neste sistema" | A conta ainda não foi criada no painel (passo 3). |
| Quero abrir a tela de configuração de novo | Acrescente `#configurar` no fim do endereço do site. |
| "Não consegui falar com o Supabase" | URL errada, ou o projeto está pausado (veja acima). |
| Tela de configuração voltou | O navegador limpou o armazenamento. Use o link de **Convidar** de novo. |
