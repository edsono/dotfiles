---
name: testing-guidelines
description: "Diretrizes de testes para o projeto fakgo (Go). Quatro camadas obrigatórias: unitário (service+inmemdb), handler (inmemdb+renderSpy), integração (handler+banco real), smoke (templates+startup). Quinta camada opcional: circuito (router completo + banco real, vários serviços). Use ao planejar ou escrever testes neste projeto."
---

# Diretrizes de Testes — fakgo

## As quatro camadas base + circuito

| Camada | Build tag | Localização | O que verifica |
|---|---|---|---|
| **Unitário** | — | `internal/service/<módulo>/<feature>_test.go` | Regras de negócio via camada de serviço com inmemdb |
| **Handler** | — | `internal/handler/<módulo>/<feature>_test.go` | Roteamento HTTP, autenticação, nome do template, dados passados ao render |
| **Integração** | `integration` | `internal/handler/<módulo>/<feature>_integration_test.go` | Caminho feliz de uma tela exercitado contra o banco de teste real |
| **Smoke** | — | `internal/server/*_test.go` | Compilação e execução sem pânico: templates + wiring da aplicação |
| **Circuito** | `integration` | `internal/handler/<módulo>/<feature>_circuito_integration_test.go` | Fluxo de negócio ponta-a-ponta atravessando vários serviços pelo router completo + middlewares |

---

## Camada 1 — Unitário (service + inmemdb)

**Padrão de setup:**
```go
repo := &inmemdb.TrabalhadoresRepo{}
orgaosRepo := &inmemdb.OrgaosRepo{}
db := &inmemdb.DB{Trabalhadores: repo, Orgaos: orgaosRepo}
svc := scad.NewTrabalhadorService(db, repo, orgaosRepo)
```

**Cobertura mínima por serviço — obrigatória:**
- **Pelo menos um caminho feliz** (happy path): operação bem-sucedida com dados válidos
- **Pelo menos um caminho infeliz** (unhappy path): DTO inválido, entidade não encontrada, ou regra de negócio violada

Testes sem esses dois casos não estão completos. Adicionar cobertura extra para:
- Regras de negócio relevantes (permissões, restrições de domínio)
- Leitura após escrita quando o serviço usa transação

**Não testar aqui:**
- Routing HTTP
- Nome do template
- SQL real

---

## Camada 2 — Handler (HTTP + inmemdb + renderSpy)

**Padrão de renderSpy:**
```go
type renderSpy struct {
    name string
    data map[string]any
}

func (s *renderSpy) render(w http.ResponseWriter, r *http.Request, name string, data map[string]any) {
    s.name = name
    s.data = data
    w.WriteHeader(http.StatusOK)
}
```

**Setup com helper:**
```go
func setupHandler(t *testing.T) (*hcad.TrabalhadorHandler, *inmemdb.TrabalhadoresRepo, *renderSpy) {
    t.Helper()
    repo := &inmemdb.TrabalhadoresRepo{}
    db := &inmemdb.DB{Trabalhadores: repo}
    svc := scad.NewTrabalhadorService(db, repo, nil)
    spy := &renderSpy{}
    h := hcad.NewTrabalhadorHandler(svc, spy.render)
    return h, repo, spy
}
```

**Cobertura mínima por handler:**
- GET da lista/consulta principal → verifica `rec.Code == 200` e `spy.name`
- Requisição não autenticada → verifica redirect para `/login`
- POST do formulário principal → verifica redirect após sucesso + estado no repo
- Caso de permissão negada → verifica 403

**Não testar aqui:**
- Renderização real do HTML
- SQL real

---

## Camada 3 — Integração (handler + banco de teste real)

Build tag obrigatória na primeira linha: `//go:build integration`

**Setup com banco real:**
```go
func setupHandlerIntegracao(t *testing.T) (*hcad.TrabalhadorHandler, *mysql.DB) {
    t.Helper()
    db := testMySQLDB(t)            // helper de repository/mysql
    repo := db.TrabalhadoresRepo()
    orgaosRepo := db.OrgaosRepo()
    svc := scad.NewTrabalhadorService(db, repo, orgaosRepo)
    h := hcad.NewTrabalhadorHandler(svc, render)
    return h, db
}
```

**Um teste por tela, exercitando o caminho feliz completo:**
```go
func TestIntegracaoCadastrarTrabalhador(t *testing.T) {
    h, db := setupHandlerIntegracao(t)
    // 1. POST do formulário
    // 2. Verifica redirect
    // 3. GET da consulta → verifica que o item aparece
    // 4. Cleanup: excluir registro criado
    t.Cleanup(func() { ... })
}
```

**Regras:**
- Cada teste deve limpar os dados que criou via `t.Cleanup`
- Usar dados gerados com o pacote `fake` para evitar conflitos
- Não usar fixtures estáticas; gerar dados únicos por execução
- O banco de teste é definido por `FAKGO_TEST_DSN` ou `DB_HOST/DB_USER/DB_NAME`; sem essas vars, o teste é ignorado com `t.Skip`

---

## Camada 4 — Smoke

### Templates

Cada template novo ou modificado deve ter um `TestRender<NomeTemplate>` em `main_test.go` que:

1. Chama `loadTemplates()` — falha aqui detecta erro de sintaxe/parse
2. Chama `render(rec, req, "caminho/template.html", data)` com dados representativos mínimos
3. Verifica `rec.Code == 200`
4. Verifica ao menos um elemento HTML fixo do template (id de tabela, campo de formulário, texto estático)

```go
func TestRenderNovoTemplate(t *testing.T) {
    middleware.SetCSRFKey(sha256.Sum256([]byte("smoke-test"))[:])
    if err := loadTemplates(); err != nil {
        t.Fatalf("erro ao carregar templates: %v", err)
    }
    req := httptest.NewRequest(http.MethodGet, "/rota", nil)
    req = req.WithContext(app.NewContextWithPrincipal(req.Context(), &app.Principal{
        Nome: "Teste", Administrador: true,
    }))
    rec := httptest.NewRecorder()
    render(rec, req, "módulo/template.html", map[string]any{"chave": valor})
    if rec.Code != http.StatusOK {
        t.Fatalf("esperado 200, obteve %d\n%s", rec.Code, rec.Body.String())
    }
    if !strings.Contains(rec.Body.String(), `id="elemento-chave"`) {
        t.Fatalf("elemento esperado ausente do HTML")
    }
}
```

**Gatilho:** sempre que um template for criado ou tiver sua assinatura de dados alterada.

### Startup

Em `main_test.go`, o teste `TestLoadTemplates` verifica que `loadTemplates()` retorna sem erro. Isso detecta erros de parse em todos os 60+ templates de uma vez.

Para testar o wiring completo sem banco, extrair `setupRoutesMock(db app.DB) http.Handler` do `main()` e testá-lo com o inmemdb:
```go
func TestStartupRotasRegistradasSemBanco(t *testing.T) {
    mux := setupRoutesMock(&inmemdb.DB{...})
    req := httptest.NewRequest(http.MethodGet, "/login", nil)
    rec := httptest.NewRecorder()
    mux.ServeHTTP(rec, req)
    if rec.Code != http.StatusOK {
        t.Fatalf("esperado 200 em /login, obteve %d", rec.Code)
    }
}
```

---

## Nomenclatura

| Camada | Padrão do nome do teste |
|---|---|
| Unitário | `Test<Serviço>_<Ação>` ex: `TestTrabalhadorService_Cadastrar` |
| Handler | `TestHandler<Ação><Cenário>` ex: `TestHandlerListarVazio` |
| Integração | `TestIntegracao<Tela><Ação>` ex: `TestIntegracaoCadastrarTrabalhador` |
| Smoke template | `TestRender<NomeTemplate>` ex: `TestRenderFormularioAtividade` |
| Smoke startup | `TestStartup<O que verifica>` ex: `TestStartupRotasRegistradas` |

---

## O que não testar em cada camada

- **Unitário**: não testar routing, nome de template, SQL real.
- **Handler**: não testar renderização HTML, não duplicar regras de negócio já cobertas no unitário.
- **Integração**: não duplicar casos de erro já cobertos no unitário; focar no caminho feliz contra dados reais.
- **Smoke de template**: não verificar lógica de negócio; focar em "o template renderiza sem pânico com dados típicos".

---

---

## Camada 5 — Circuito (router completo + banco real + vários serviços)

Convenção: **1 a 3 circuitos por módulo**, cada um exercitando um fluxo de
negócio que atravessa vários serviços pela pilha HTTP completa
(Flash → CSRF → AuthMiddleware → Autorizacao → Recovery → Logging → RequestID).

**Quando usar:** quando um caminho de negócio relevante só pode ser validado
passando por mais de um serviço ou quando o middleware de Autorizacao é parte
crítica do que está sendo testado.

Build tag obrigatória: `//go:build integration` (igual à camada 3).
Nomenclatura do arquivo: `<feature>_circuito_integration_test.go`.
Nomenclatura do teste: `TestCircuito<Fluxo>` ex: `TestCircuitoCadastrarEDesignarDiretor`.

### Wiring — `testserver.Harness`

O router completo é montado via `server.New` (pacote `internal/server`, que
encapsula `setupRoutes` + lookups de `PrincipalLookup`/`AutoAuthLookup` +
chaves + templates). O harness de teste vive em
`internal/testutils/testserver/` (arquivos com `//go:build integration`).

```go
// Obtém o harness (banco real + router completo + Telegram inativo)
h := testserver.New(t)  // chama testdb.TestMySQLDB(t); faz t.Skip sem DB_*

// Autentica: gera cookie de sessão apontando para usuário no banco real
cookie := h.Login(usuarioID)

// Executa uma requisição autenticada com CSRF resolvido automaticamente
rec := h.Do(httptest.NewRequest("GET", "/cadastros/trabalhadores", nil), cookie)
```

### Autenticação pela stack real

`h.Login(id)` usa `middleware.SalvarSessao(rec, middleware.Session{UserID: id})`
e extrai o cookie `fak_session` de `rec.Result().Cookies()`. Nas requisições
seguintes, o `AuthMiddleware` lê o cookie, chama o `principalLookup` registrado
por `server.New` (que consulta `db.UsuariosRepo().ObterPorID`) e popula o
contexto com o `Principal` real.

### CSRF

O middleware CSRF é stateless (HMAC-SHA256). O harness gera um token válido com
`middleware.CSRFValue(req)` e o injeta no header `X-CSRF-Token` de cada POST
via `h.Do`. GETs passam sem token (CSRF só bloqueia métodos não-idempotentes).

### Telegram em testes de circuito

Para circuitos que testam notificações, passar `httptest.Server` como endpoint
via `TelegramService.ConfigurarParaTeste(endpoint, client, sleep)`
(`notificacoes/notificar_telegram.go:43`). Para circuitos que não testam
notificações, usar Telegram inativo: `NewTelegramService("", "", false, false, false)`.

### Seed e cleanup

Seed via repos reais em transação + `internal/testutils/fake`; cleanup via
`t.Cleanup` removendo os registros criados. Padrão idêntico à camada 3.

### Exemplo esquelético

```go
//go:build integration

package cadastros_test

func TestCircuitoCadastrarEAcompanhar(t *testing.T) {
    h := testserver.New(t)

    // seed: criar usuário ator no banco
    atorID := h.SeedUsuarioAdmin(t)
    cookie := h.Login(atorID)

    // POST /cadastros/trabalhadores/cadastrar
    form := "cpf=529.982.247-25&nome_completo=Maria+Circuito&..."
    req := httptest.NewRequest("POST", "/cadastros/trabalhadores/cadastrar",
        strings.NewReader(form))
    req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
    rec := h.Do(req, cookie)
    if rec.Code != http.StatusFound {
        t.Fatalf("esperado 302, obteve %d\n%s", rec.Code, rec.Body.String())
    }

    // GET /cadastros/trabalhadores/acompanhamento
    req = httptest.NewRequest("GET", "/cadastros/trabalhadores/acompanhamento", nil)
    rec = h.Do(req, cookie)
    if rec.Code != http.StatusOK {
        t.Fatalf("esperado 200, obteve %d", rec.Code)
    }

    t.Cleanup(func() {
        // excluir trabalhador + usuário criados
    })
}
```

---

## Execução

```bash
just test                           # camadas 1, 2 e 4 (smoke agora em internal/server)
just test-integration               # camadas 3 e 5 (requer DB_* ou FAKGO_TEST_DSN)
just test-all                       # todas as camadas
```
