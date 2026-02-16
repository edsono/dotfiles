---
name: naming-verbs
description: Layered naming rules for methods, files, routes, views, and templates using Portuguese verbs. Use when naming repository, service, view, or template actions in this Django codebase.
---

# Layered Verb Naming (Portuguese)

Use the verb lists below when naming methods, services, views, routes, and templates. The English text here explains the rules, but the **verbs themselves remain in Portuguese**.

## 1. Repository Layer (Model Manager / Data Access)
Use technical, neutral verbs:

- `criar` – create data
- `alterar` – update data
- `salvar` – create or update
- `obter` – fetch by primary key
- `buscar` – search by attributes
- `remover` – delete (hard delete)
- `existe` – existence check
- `listar` – list all, with or without filters
- `contar` – count records
- `validar` – technical consistency validation
- `normalizar` – technical data normalization

Keep names short and do not encode business rules here.

## 2. Service Layer (Domain / Application Services)
Use verbs that express **business intent**.

### Entity verbs (Parte, Pessoa, Instituição, Lugar)
- `cadastrar` – new record with validation
- `atualizar` – update data
- `consultar` – display/query data
- `visualizar` – document preview
- `corrigir` – fix inconsistencies
- `excluir` – logical delete / business rule
- `ativar` – activate status
- `inativar` – deactivate status

### Role verbs (Usuário, Liderança, etc.)
- `designar` – assign role or link
- `retificar` – alter role or permission
- `revogar` – remove role
- `vincular` – link entities
- `desvincular` – unlink entities

### Transaction verbs (Eventos entre entidades/papéis)
- `registrar` – formal transaction
- `confirmar` – validate/accept
- `cancelar` – cancel with rule
- `estornar` – reverse operation
- `notificar` – business event communication

### Specific domain action
- `encerrar` – end a role/cycle of activity

### Reference tables
If the table is a reference table persisted in the DB, use **repository verbs**.

## 3. View / Template Layer
Use the **same verb** as the service the view/template calls.

Examples:
- Service: `cadastrar_usuario` → Template: `cadastrar_usuario.html` → View: `CadastrarUsuarioView`
- For documents, use the verb `visualizar` in views and templates.

## UI Labels
- DataTables: use label `Editar` for update actions and `Excluir` for removals.

## Data Dictionary Alignment
Use the data dictionary terms in models/fields (Entidade, Papel, Transação, Item de transação, Tabela de Referência) to choose the most appropriate verb in the service and its view/template.
