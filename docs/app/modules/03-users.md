# Usuários

## Objetivo

Permitir o gerenciamento dos usuários do sistema.

**Acesso restrito:** apenas usuários com perfil **Admin** ou **Qualidade**.

---

## Funcionalidades

- Cadastro de usuários.
- Edição de usuários.
- Ativar usuário.
- Desativar usuário.
- Exclusão de usuários.
- Pesquisa por nome ou usuário.
- Filtro por perfil.
- Paginação.
- Listagem de usuários ativos.
- Listagem de usuários inativos.

---

## Fluxo

01. Usuário acessa o módulo de usuários.
02. Sistema exibe os usuários ativos.
03. Usuário pode pesquisar ou filtrar registros.
04. Usuário pode cadastrar, editar, ativar, desativar ou excluir um usuário.
05. Sistema atualiza a listagem.

---

## Estrutura da tela

### Cabeçalho

- Título da página.
- Descrição.
- Botão **Novo usuário**.

---

### Resumo

Cards com informações:

- Total de usuários.
- Usuários ativos.
- Usuários inativos.
- Administradores.

---

### Filtros

- Pesquisa.
- Perfil de acesso.
- Limpar filtros.

---

### Usuários ativos

Exibe apenas usuários ativos.

Cada registro apresenta:

- Nome.
- Usuário.
- Perfil.
- Status.
- Ações.

Possui paginação.

---

### Usuários inativos

Exibe apenas usuários inativos.

- Inicia recolhido por padrão.
- Possui paginação independente.
- Pode ser expandido quando necessário.

---

## Cadastro

Campos:

- Nome completo.
- Nome de usuário.
- Perfil de acesso.
- Usuário ativo.

---

## Ações

Para cada usuário é possível:

- Editar o cadastro.
- Ativar.
- Desativar.
- Excluir.

---

## Regras

- Apenas usuários com perfil **Admin** ou **Qualidade** podem acessar este módulo.
- O nome de usuário deve ser único.
- Não permitir nomes de usuário duplicados.
- Usuários inativos não podem acessar o sistema.
- Exclusões devem solicitar confirmação.
- Todas as alterações devem ser registradas na auditoria.

---

## Paginação

- Usuários ativos possuem paginação própria.
- Usuários inativos possuem paginação própria.

---

## Arquivos

```
lib/modules/users/
```

---

## Dependências

- UserRepository
- AuthService
- SessionManager

---

## Melhorias futuras

- Último acesso.
- Data de criação.
- Criado por.
- Última alteração.
- Alterado por.
- Auditoria completa.