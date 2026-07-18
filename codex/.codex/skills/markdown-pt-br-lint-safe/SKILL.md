---
name: markdown-pt-br-lint-safe
description: Use quando o usuário pedir para criar, revisar ou salvar
  arquivos Markdown neste repositório e o resultado precisar ficar
  compatível com markdownlint, sempre em português do Brasil quando o
  conteúdo for textual.
---

# Markdown PT-BR Lint Safe

## Visão geral

Use esta skill para produzir Markdown que passe em `markdownlint`
sem exigir retrabalho manual no editor.

## Quando usar

- Ao criar ou editar arquivos `*.md`.

- Ao escrever specs, planos, documentação técnica ou skills.

- Ao converter texto livre para Markdown versionado no repositório.

## Regras obrigatórias

- Escreva em português do Brasil quando o conteúdo for textual, salvo
  pedido explícito em outro idioma.

- Quebre linhas longas para no máximo 80 colunas.

- Deixe uma linha em branco antes e depois de headings.

- Deixe uma linha em branco antes e depois de listas.

- Deixe uma linha em branco entre cada item de lista, numerada ou não.

- Deixe uma linha em branco antes e depois de fenced code blocks.

- Sempre declare a linguagem do fenced code block, como `bash`, `md`,
  `python` ou `text`.

- Não repita headings com o mesmo texto no mesmo documento.

- Não aninhe blocos com crases triplas dentro de outro bloco com crases
  triplas. Quando precisar mostrar Markdown com fences, use `~~~`.

## Estrutura segura

Prefira este padrão:

1. Título H1

2. Heading H2

3. Parágrafo curto

4. Lista com linha em branco antes

5. Bloco de código com linguagem e linha em branco antes e depois

## Exemplo seguro

~~~md
# Título do documento

## Seção

Texto introdutório curto.

- Item 1

- Item 2

```bash
just test
```
~~~

## Validação

Quando for possível validar localmente, use:

~~~bash
npx -y markdownlint-cli2 caminho/do/arquivo.md
~~~

Se existir `.markdownlint.json` na raiz do projeto, siga esse arquivo
como fonte principal das regras.
