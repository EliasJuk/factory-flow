# Estrutura do projeto

## main.dart

Responsável por iniciar a aplicação.

- Ponto de entrada da aplicação.
- Chama o `FactoryFlowApp`.
- Não deve conter regras de negócio.

---

## app.dart

Responsável por configurar a aplicação.

- `MaterialApp`
- Temas
- Rotas
- Configurações globais
- Providers globais (quando existirem)

---

## modules/

Contém os módulos da aplicação.

Cada módulo é responsável por uma funcionalidade do sistema.

Exemplos:

- Login
- Usuários

---

## theme/

Contém a identidade visual da aplicação.

- Cores
- Temas Light
- Temas Dark

---