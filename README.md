# Carrinho de Compras

API de um carrinho de compras construída com Ruby on Rails.

O projeto consiste em uma API RESTful que gerencia o ciclo de vida de um carrinho de compras, desde a adição de produtos até a limpeza de carrinhos abandonados através de um processo em segundo plano.

## Princípios de Design Adotados

O desenvolvimento seguiu os princípios e foco em:

- **Código Limpo e Legível:** A lógica foi separada em `Concerns` (para gerenciamento do carrinho na sessão) e `Presenters` (para formatação das respostas JSON), mantendo os controllers enxutos e focados.
- **Performance:** Foram utilizadas técnicas como `.includes` para evitar queries N+1 e índices em colunas do banco de dados que são frequentemente consultadas.
- **Cobertura de Testes:** A aplicação possui uma suíte de testes (RSpec) que cobre todos os endpoints e a lógica do job, incluindo cenários de sucesso e de erro.

---

## Informações Técnicas

- **Ruby:** `3.3.1`
- **Rails:** `7.1.3.2`
- **Banco de Dados:** PostgreSQL 16
- **Jobs em Background:** Sidekiq com Redis

---

## Como Executar o Projeto

Existem duas maneiras de executar a aplicação localmente.

### Executando Localmente

**Pré-requisitos:**

- Ruby `3.3.1` (recomenda-se usar `rbenv`)
- Bundler
- PostgreSQL 16
- Redis

**Passos:**

1.  **Instale as dependências do projeto:**

    ```bash
    bundle install
    ```

2.  **Prepare o banco de dados:**

    ```bash
    bin/rails db:create
    bin/rails db:migrate
    bin/rails db:seed
    ```

3.  **Inicie o Sidekiq:**
    Abra um terminal e execute o processo do Sidekiq. Ele ficará escutando por novos jobs.

    ```bash
    bundle exec sidekiq
    ```

4.  **Inicie o servidor Rails:**
    Abra **outro** terminal e inicie o servidor da aplicação.
    ```bash
    bin/rails s
    ```

A aplicação estará disponível em `http://localhost:3000`.

---

## Como Executar os Testes

Para rodar a suíte de testes completa e garantir que tudo está funcionando como esperado, execute:

```bash
bundle exec rspec
```
