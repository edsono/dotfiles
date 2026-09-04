# Diretrizes globais

Estas diretrizes valem para qualquer projeto. Regras de um `AGENTS.md`
ou `CLAUDE.md` de projeto têm prioridade sobre estas.

## Idioma

- Responder em português do Brasil.

- Mensagens de commit em português.

- Documentação `*.md` com acentuação e ortografia corretas; não remover
  acentos.

## Git

- Pode fazer `git commit` sem me pedir autorização a cada vez.

- Nunca executar `git push`, `git reset`, `git rebase` ou qualquer outra
  mutação no repositório sem solicitação explícita.

- Antes de commitar, apresentar `git status` e `git diff --stat`.

- Se estiver na branch padrão (`master` ou `main`), criar uma branch
  antes de commitar.

## Planejamento

- Fazer perguntas numeradas somente quando houver dúvida bloqueante.

- Sem dúvida bloqueante, apresentar plano enxuto em bullets e pedir
  aprovação.

- Planejamento, revisão e decisões de design ficam no modelo da sessão
  atual, não em subagente.

## Delegação a subagentes

- Despachar para subagente quando houver escopo isolável e verificação
  objetiva.

- Esforço baixo: usar `executor-mecanico`. Passo a passo já inteiramente
  escrito e sem decisão a tomar, aplicar diff ou refactor mecânico já
  especificado, renomear, rodar comandos e colar saída, regenerar
  arquivos derivados.

- Esforço médio ou alto: usar `implementador`. Qualquer decisão de
  código, debugging, escrita de teste novo ou interpretação de spec. Na
  dúvida, usar esforço médio ou alto.

- Revisão de código sem alteração: usar `revisor`. Escalar para modelo
  mais forte quando a revisão envolver autorização, sessão, transação ou
  coerência arquitetural entre camadas.

- Edições em arquivos não devem usar modelo acima de Sonnet 5. Se a
  tarefa pedir modelo mais caro, interromper e pedir confirmação
  explícita antes de prosseguir.
