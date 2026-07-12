# Configurações

## Objetivo

Centralizar as configurações gerais do nosso projeto.

Inicialmente, o módulo será responsável pelas configurações relacionadas ao armazenamento e à conexão com o banco de dados.

---

## Acesso

**Acesso restrito:** apenas usuários com perfil **Admin** ou **Qualidade**.

---

## Funcionalidades

```
- Selecionar o modo de armazenamento.
- Configurar o banco SQLite local.
- Configurar uma conexão direta com PostgreSQL.
- Preparar a configuração para conexão via API.
- Configurar sincronização do banco local.
- Restaurar os valores padrão da tela.
- Salvar configurações.
- Testar conexões futuramente.
```

```
- seleção do modo de armazenamento
- configuração SQLite
- configuração PostgreSQL
- interface da API
- configuração de sincronização
- layout responsivo
- componentes reutilizáveis
```

#### Ainda não implementado:

- salvar configurações
- carregar configurações
- teste de conexão
- comunicação com API
- sincronização SQLite ⇄ PostgreSQL
- sincronização SQLite ⇄ API

---

## Fluxo

01. Usuário acessa o módulo de configurações.
02. Sistema exibe os modos de armazenamento disponíveis.
03. Usuário seleciona SQLite, API ou PostgreSQL direto.
04. Sistema exibe os campos correspondentes ao modo selecionado.
05. Usuário informa ou altera os dados de configuração.
06. Usuário pode restaurar os valores padrão.
07. Usuário salva as configurações.
08. Futuramente, o sistema validará a conexão antes de aplicar as alterações.

---

## Estrutura da tela

### Cabeçalho

- Título da página.
- Aba **Banco de dados**.
- Botão para retornar ao Dashboard.

---

### Modo de armazenamento

O sistema apresenta três opções:

- SQLite local.
- API.
- PostgreSQL direto.

Cada opção possui:

- Ícone.
- Nome.
- Descrição.
- Indicador de seleção.
- Tooltip explicativo.

---

## SQLite local

Os dados são armazenados no computador onde o FactoryFlow está instalado.

### Campos

- Caminho do arquivo SQLite.

### Ações

- Testar banco local.
- Ativar sincronização.

### Características

- Funcionamento offline.
- Baixa dependência de infraestrutura externa.
- Dados armazenados localmente.
- Pode ser usado com sincronização futura.

---

## Sincronização

Disponível quando o modo SQLite local estiver selecionado.

### Destinos

- PostgreSQL direto.
- API.

### Opções

- Ativar sincronização.
- Sincronizar ao iniciar.
- Sincronizar ao recuperar a conexão.
- Repetir operações que apresentarem erro.
- Testar destino remoto.

### Estado atual

A sincronização ainda não está implementada.

---

## API

O aplicativo utilizará uma API intermediária para acessar os dados.

### Campos

- URL base da API.
- Método de autenticação.
- Token ou API Key.
- Timeout.
- Validar certificado SSL.
- Repetir requisições com erro.

### Métodos de autenticação

- Bearer Token.
- API Key.
- Sem autenticação.

### Ações

- Testar conexão com a API.

### Estado atual

A interface está pronta, mas:

- As configurações ainda não são persistidas.
- Nenhuma requisição HTTP é executada.
- A API ainda será criada.
- A API poderá ser executada em um container Docker.

---

## PostgreSQL direto

O aplicativo acessará diretamente um banco PostgreSQL remoto.

### Campos

- Host.
- Porta.
- Banco de dados.
- Usuário.
- Senha.
- Timeout.
- Usar conexão SSL.

### Ações

- Testar conexão.

### Características

- Depende de conexão com o servidor.
- Não possui funcionamento offline.
- O aplicativo acessa diretamente o banco.
- Não utiliza uma API intermediária.

---

## Regras

- Apenas usuários com perfil **Admin** ou **Qualidade** podem acessar o módulo.
- Apenas um modo de armazenamento pode estar ativo.
- A sincronização pode ser habilitada somente no modo SQLite local.
- Credenciais não devem ser armazenadas diretamente no código-fonte.
- Senhas, tokens e API Keys não podem aparecer em logs.
- Arquivos com credenciais reais não podem ser enviados ao GitHub.
- O botão de salvar deve validar os campos obrigatórios.
- Mudanças de configuração devem solicitar confirmação futuramente.
- Alterações importantes devem ser registradas na auditoria.

---

## Validações futuras

### SQLite

- Verificar se o caminho informado é válido.
- Verificar permissão de leitura e escrita.
- Verificar se o banco pode ser aberto.

### API

- Validar o formato da URL.
- Validar o timeout.
- Verificar o certificado SSL.
- Executar um teste de disponibilidade.
- Validar as credenciais.

### PostgreSQL

- Validar host e porta.
- Validar nome do banco.
- Testar autenticação.
- Verificar conexão SSL.
- Verificar o acesso ao schema esperado.

---

## Decisões de arquitetura

- A interface não deve conhecer diretamente a implementação do banco.
- O acesso aos dados será realizado por repositórios.
- O modo de armazenamento será selecionado por uma camada de configuração.
- A API terá suas rotas definidas internamente no código.
- Os endpoints não serão configurados manualmente pelo usuário.
- A versão da API será definida internamente.
- As credenciais serão movidas para variáveis de ambiente ou armazenamento seguro.

Fluxo planejado:

```text
Interface
    ↓
Services
    ↓
RepositoryFactory
    ↓
SQLite | API | PostgreSQL

---

# PostgreSQL Direto

Neste modo o FactoryFlow conecta diretamente ao banco PostgreSQL, sem utilizar uma API intermediária.

Este modo é recomendado para ambientes onde existe um servidor PostgreSQL disponível na rede local ou na internet.

---

## Características

- conexão direta com PostgreSQL
- não utiliza SQLite
- não utiliza sincronização
- todos os dados são gravados diretamente no servidor
- ideal para ambientes corporativos

---

## Campos

### Host

Endereço IP ou nome do servidor.

Exemplos:

```
192.168.0.10
servidor.local
db.factoryflow.local
```

---

### Porta

Porta utilizada pelo PostgreSQL.

Padrão:

```
5432
```

---

### Banco de dados

Nome do banco onde o FactoryFlow armazenará os dados.

Exemplo:

```
factoryflow
```

---

### Usuário

Usuário utilizado para autenticação.

---

### Senha

Senha do usuário informado.

A senha é ocultada durante a digitação.

---

### Timeout

Tempo máximo para aguardar resposta do servidor.

Valor sugerido:

```
15 segundos
```

---

### SSL

Quando habilitado, toda comunicação entre o aplicativo e o servidor será criptografada.

---

## Botões

- Testar conexão

---

## Estado atual

A interface está concluída.

O teste de conexão ainda será implementado.

---

# Regras

O módulo deve seguir algumas regras para garantir a consistência das configurações.

## Modo de armazenamento

- Apenas um modo pode permanecer ativo.
- Alterar o modo não deve apagar configurações anteriores.
- O último modo utilizado deverá ser carregado automaticamente.

---

## SQLite

- Caminho deve ser válido.
- Banco deve existir ou ser criado automaticamente.
- Permissões de leitura e escrita devem ser verificadas.

---

## API

- URL obrigatória.
- Timeout deve ser maior que zero.
- Token somente quando necessário.
- SSL opcional.

---

## PostgreSQL

- Host obrigatório.
- Porta obrigatória.
- Banco obrigatório.
- Usuário obrigatório.
- Senha obrigatória.
- Timeout obrigatório.

---

## Segurança

- Nunca armazenar credenciais diretamente no código.
- Nunca enviar arquivos `.env` ao Git.
- Nunca registrar senhas ou tokens em logs.
- Utilizar armazenamento seguro para credenciais.

---

# Validações

## SQLite

- caminho existente
- permissão de escrita
- criação automática do banco
- abertura do banco

---

## API

- URL válida
- autenticação válida
- timeout válido
- resposta da API
- certificado SSL

---

## PostgreSQL

- host acessível
- porta aberta
- autenticação
- existência do banco
- permissão de acesso
- SSL

---

# Arquitetura

O módulo de configurações não acessa diretamente SQLite, PostgreSQL ou API.

Toda comunicação ocorre através das camadas de serviço e repositórios.

Fluxo previsto:

```text
Tela

↓

ConfigService

↓

RepositoryFactory

↓

SQLiteRepository
ApiRepository
PostgresRepository
```

Dessa forma a interface permanece desacoplada da implementação do banco de dados.

---

## Seleção do provider

A configuração escolhida pelo usuário determina qual implementação será utilizada.

```text
SQLite Local
        │
        ▼
SQLiteRepository

API
        │
        ▼
ApiRepository

PostgreSQL
        │
        ▼
PostgresRepository
```

Nenhuma tela da aplicação conhece diretamente qual banco está sendo utilizado.

---

# Dependências

Este módulo depende dos seguintes componentes da aplicação.

## Implementados

- DatabaseModeOption
- RemoteConnectionSettings
- DatabaseSettings
- Material Design

---

## Planejados

- Config
- ConfigService
- ApiClient
- SecureStorage
- SessionManager
- RepositoryFactory
- DatabaseManager

---

# Situação atual

## Implementado

- Página de configurações
- Seleção do modo de armazenamento
- SQLite Local
- PostgreSQL Direto
- Interface da API
- Configuração de sincronização
- Layout responsivo
- Tooltips
- Componentes reutilizáveis
- Interface preparada para futuras integrações

---

## Em desenvolvimento

- Persistência das configurações
- Teste de conexão SQLite
- Teste de conexão PostgreSQL
- Teste de conexão API

---

## Planejado

- API completa
- Sincronização
- Backup
- Criptografia
- Perfis de conexão

---

# Decisões de arquitetura

Durante o desenvolvimento algumas decisões importantes foram adotadas.

## API

O usuário informa apenas:

- URL da API
- autenticação
- timeout

Os endpoints permanecem definidos internamente no código.

Isso reduz configurações incorretas e facilita futuras atualizações.

---

## Versionamento

A versão da API não será configurável pelo usuário.

Ela permanecerá definida internamente.

Exemplo:

```
/api/v1
```

Caso exista uma futura versão:

```
/api/v2
```

A alteração será realizada apenas no código da aplicação.

---

## Credenciais

As credenciais não permanecerão armazenadas em arquivos do projeto.

Serão utilizadas variáveis de ambiente e armazenamento seguro.

---

## Configuração

Toda configuração da aplicação será centralizada futuramente em uma única classe.

Exemplo:

```
Config
```

Essa classe será responsável por disponibilizar todas as configurações da aplicação.

---

# Padrões adotados

Este módulo segue os padrões arquiteturais utilizados em todo o nosso projeto.

- Componentes reutilizáveis.
- Interface desacoplada do banco.
- Repository Pattern.
- Services para regras de negócio.
- Separação entre Interface e Persistência.
- Código organizado por módulos.
- Configurações centralizadas.
- Documentação obrigatória.

---

# Roadmap

## Próxima etapa

- mover credenciais para `.env`
- criar `.env.example`
- adicionar `.env` ao `.gitignore`
- criar classe `Config`
- persistir configurações
- implementar teste de conexão PostgreSQL

---

## Médio prazo

- implementar API
- criar cliente HTTP
- autenticação por token
- sincronização SQLite ⇄ API
- sincronização SQLite ⇄ PostgreSQL

---

## Longo prazo

- múltiplos perfis de conexão
- backup automático
- criptografia das credenciais
- monitor de conexão
- atualização automática
- sincronização incremental
- auditoria das alterações

---

# TODO

## Alta prioridade

- Persistir configurações.
- Criar ConfigService.
- Implementar SecureStorage.
- Implementar testes de conexão.

---

## Média prioridade

- Criar API.
- Cliente HTTP.
- Sincronização.

---

## Baixa prioridade

- Backup.
- Perfis de conexão.
- Importação e exportação das configurações.
- Assistente de configuração inicial.

---

# Observações

## Arquivo `.env`

As credenciais utilizadas durante o desenvolvimento não devem permanecer no código-fonte.

Será utilizado um arquivo `.env` contendo, por exemplo:

```text
DB_HOST=
DB_PORT=
DB_NAME=
DB_USER=
DB_PASSWORD=

API_URL=
API_TOKEN=
```

O arquivo `.env` será ignorado pelo Git.

Será disponibilizado apenas um arquivo `.env.example`.

---

## Configuração centralizada

Todas as configurações da aplicação deverão ser acessadas através de uma classe única.

Exemplo:

```text
Config
```

Essa classe será responsável por fornecer:

- configurações do banco
- configurações da API
- ambiente
- timeout
- autenticação
- demais parâmetros globais

---

# Considerações finais

O módulo **Configurações** representa a base da infraestrutura do projeto.

Embora atualmente possua apenas a interface de configuração, toda sua arquitetura foi planejada para permitir a evolução da aplicação sem alterações significativas nas demais telas.

A separação entre Interface, Services, RepositoryFactory e Repositories garante que novos mecanismos de armazenamento possam ser adicionados futuramente com baixo impacto no restante do sistema, mantendo a escalabilidade, organização e facilidade de manutenção do projeto.