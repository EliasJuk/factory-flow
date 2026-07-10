# Login

## Objetivo

Permitir a autenticação de usuários no sistema.

## Funcionalidades

- Login por usuário e senha.
- Logout.
- Lembrar usuário (opcional).
- Alteração de senha.
- Recuperação de senha.

## Fluxo

01. Usuário informa login.
02. Usuário informa senha.
03. Sistema valida as credenciais.
04. Sistema cria a sessão.
05. Usuário é redirecionado ao Dashboard.

## Regras

- Usuário inativo não pode acessar.
- Login diferencia maiúsculas e minúsculas (opcional).
- Senha permanece oculta por padrão.
- Permissões são carregadas após o login.

## Arquivos

lib/modules/login/

## Dependências

- AuthService
- UserRepository
- SessionManager

---

## Regras importantes:

### Recuperação de senha

#### O usuário clica em:
```m
"Esqueci minha senha"
```


```md
# Fluxo:

Solicitação criada
        ↓
Admin/Qualidade confirma o usuário
        ↓
Sistema gera senha temporária
        ↓
Usuário entra com a senha temporária
        ↓
Sistema exige uma nova senha
        ↓
Solicitação é concluída
```


```md
# Regras
- Apenas *Admin* ou *Qualidade* podem redefinir a senha.
- A senha atual nunca pode ser exibida.
- A *Qualidade* ou o *Admin* geram uma senha temporária.
- A senha temporária deve ser alterada no primeiro login.
- A solicitação deve registrar quem atendeu e quando.
- A redefinição deve ser registrada na auditoria.
- A senha nunca deve aparecer nos registros de auditoria.
```