---
name: spec-pt-br
description: Use quando o usuário pedir para criar, adaptar ou salvar uma
  spec técnica neste repositório, especialmente no formato
  Goal/Requirements/Constraints/Acceptance criteria/Context, sempre
  redigida em português do Brasil e preferencialmente salva em docs/specs.
---

# Spec em Português BR

## Visão geral

Use esta skill para transformar um pedido técnico em uma spec curta,
verificável e pronta para implementação. A saída deve ficar em
português do Brasil, com linguagem objetiva e critérios concretos.

Siga também a skill `$markdown-pt-br-lint-safe` sempre que o resultado
for um arquivo Markdown.

## Quando usar

- Quando o usuário pedir "crie um spec", "escreva uma spec", "salve essa
  spec" ou "adapte esse plano para spec".

- Quando houver um plano aprovado e for preciso convertê-lo em
  documentação executável.

- Quando for necessário registrar uma spec versionada dentro do projeto,
  preferencialmente em `docs/specs`.

## Resultado esperado

A spec deve:

- deixar claro o objetivo final em uma frase;

- listar requisitos verificáveis e independentes;

- limitar escopo com restrições explícitas;

- definir critérios de aceitação copiáveis;

- apontar arquivos, exemplos e referências do repositório.

## Estrutura padrão

Use estas seções, nesta ordem:

1. `Objetivo`

2. `Requisitos`

3. `Restrições`

4. `Critérios de aceitação`

5. `Contexto`

Se necessário, a spec pode incluir as seções opcionais
`Detalhes de implementação` e `Pressupostos` ao final. Quando a seção
`Detalhes de implementação` existir, ela deve vir antes de
`Pressupostos`.

Na primeira redação da spec, especialmente quando ela ainda será criada
ou salva pela primeira vez em `docs/specs`, não incluir
`Detalhes de implementação`.

`Detalhes de implementação` só pode ser acrescentada em uma segunda
interação, quando a spec já existir em arquivo ou já tiver sido gravada
anteriormente no repositório.

Se o usuário fornecer um template em inglês como `Goal`,
`Requirements`, `Constraints`, `Acceptance criteria`, `Context` ou
`Assumptions`, mantenha a mesma estrutura conceitual, mas escreva os
títulos e o conteúdo em português do Brasil, salvo se ele pedir
explicitamente para preservar os títulos em inglês.

## Regras de escrita

- Use português do Brasil com acentuação correta.

- Prefira frases curtas e termos concretos.

- Não use adjetivos vagos como "rápido", "limpo", "moderno" ou
  "robusto" sem métrica.

- Cada requisito deve poder ser validado isoladamente.

- Cada restrição deve reduzir espaço para interpretação do implementador.

- Cada critério de aceitação deve ser executável ou observável de forma
  objetiva.

- Quando citar comandos, use blocos `bash` copiáveis.

- Quando citar arquivos do projeto, prefira caminhos reais do
  repositório.

- Em listas numeradas ou com bullets, deixe uma linha em branco entre
  os itens.

## Padrões de conteúdo

### Objetivo

- Uma frase.

- Explica o que significa sucesso no nível mais alto.

- Deve servir como referência caso a implementação fique ambígua.

### Requisitos

- Lista numerada.

- Cada item descreve algo que obrigatoriamente deve ser verdade ao
  final.

- Evite juntar duas obrigações diferentes no mesmo item.

### Restrições

- Lista numerada.

- Registra o que não deve ser alterado, ampliado ou inferido.

- Use para bloquear mudanças de UX, schema, canais, integrações ou
  refactors fora do escopo.

### Critérios de aceitação

- Liste comandos, testes, checks manuais ou asserts observáveis.

- Dê preferência a `uv run pytest`, `just lint`, `just test` e comandos
  reais do projeto.

- Se não houver um comando executável ainda, descreva a verificação
  manual de forma objetiva.

### Contexto da spec

- Aponte 3 a 8 arquivos ou documentos relevantes.

- Inclua exemplos já existentes quando ajudarem a reduzir ambiguidade.

- Não replique o conteúdo desses arquivos; apenas referencie.

### Detalhes de implementação

- Seção opcional.

- Não usar na criação inicial do arquivo da spec.

- Usar apenas em uma iteração posterior, quando a spec já existir no
  repositório e o usuário pedir para complementá-la com direcionamento
  de implementação.

- Use quando a spec precisar orientar a implementação com mais precisão
  sem exigir um plano separado.

- Registre decisões de modelagem, fluxo, regras de precedência,
  heurísticas, mapeamentos ou pontos delicados de integração.

- Prefira bullets curtos agrupados por comportamento ou subsistema.

- Não transforme a seção em inventário arquivo a arquivo, salvo quando
  isso for necessário para evitar ambiguidade.

### Pressupostos

- Seção opcional.

- Use apenas quando houver defaults escolhidos, hipóteses assumidas ou
  decisões não explícitas no pedido original.

- Registre somente pressupostos que mudam a implementação ou evitam
  ambiguidade.

## Convenções deste repositório

- Preferir salvar a spec em `docs/specs/`.

- Usar nomes de arquivo no formato `YYYY-MM-DD-slug-da-spec.md`.

- Manter o documento em Markdown puro.

- Se já existir um plano em `docs/plans/`, converter o conteúdo para
  spec sem misturar os dois formatos.

## Fluxo recomendado

1. Ler o pedido do usuário e o contexto local mínimo necessário.

2. Identificar o escopo real e os exemplos existentes no repositório.

3. Escrever a spec inicial em português do Brasil usando a estrutura
   padrão, sem `Detalhes de implementação`.

4. Se o usuário pedir para salvar, criar ou atualizar o arquivo em
   `docs/specs/`.

5. Somente depois de a spec já existir em arquivo, acrescentar
   `Detalhes de implementação` se o usuário pedir esse nível adicional
   de precisão.

6. Manter a spec concisa, específica e pronta para implementação.

## Exemplo de saída

~~~md
# Spec — Nome da funcionalidade

## Objetivo

Implementar ...

## Requisitos

1. ...

2. ...

## Restrições

1. ...

2. ...

## Critérios de aceitação

1. Executar:

   ```bash
   uv run pytest src/app/tests/test_exemplo.py
   ```

## Contexto

- `docs/plans/...`

- `src/app/services/...`

## Pressupostos

- Usar o padrão existente de autenticação do projeto.
~~~
