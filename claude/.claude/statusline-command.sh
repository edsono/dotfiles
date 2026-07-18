#!/usr/bin/env bash
# Claude Code statusLine
# ~/Code/FAK/Ruler  main*↑2 │ Opus 4.8 ███░░░░░░░ 28% │ 5h 12% · wk 40%

# printf %.0f respeita LC_NUMERIC; em locales com vírgula decimal ele rejeita "28.4".
export LC_ALL=C

input=$(cat)

# Um único processo jq extrai tudo. Separador é 0x1f (unit separator) e não TAB:
# TAB conta como IFS-whitespace no `read`, o que colapsaria campos vazios e
# deslocaria todos os valores seguintes.
IFS=$'\x1f' read -r cwd model used_pct total_input ctx_size fh_pct fh_reset sd_pct sd_reset <<<"$(
  printf '%s' "$input" | jq -r '
    [ (.workspace.current_dir // .cwd // ""),
      (.model.display_name // ""),
      (.context_window.used_percentage // ""),
      (.context_window.total_input_tokens // ""),
      (.context_window.context_window_size // ""),
      (.rate_limits.five_hour.used_percentage // ""),
      (.rate_limits.five_hour.resets_at // ""),
      (.rate_limits.seven_day.used_percentage // ""),
      (.rate_limits.seven_day.resets_at // "")
    ] | map(tostring) | join("\u001f")' 2>/dev/null
)"
: "${cwd:=$PWD}"

R=$'\033[0m' DIM=$'\033[2m'
BLUE=$'\033[1;34m' MAGENTA=$'\033[0;35m' CYAN=$'\033[1;36m' YELLOW=$'\033[0;33m'
GREEN=$'\033[0;32m' ORANGE=$'\033[1;33m' RED=$'\033[1;31m'

# Limiares de atenção: abaixo de WARN é verde/cinza, a partir daí laranja, e
# vermelho a partir de CRIT. Contexto tem par próprio (50/80) porque a
# degradação ali é gradual e vale avisar mais cedo — não há threshold "crítico"
# real como no uso de assinatura, que é binário (deu ou não deu o limite).
WARN=70 CRIT=90
CTX_WARN=50 CTX_CRIT=80

color_for() { # $1 = percentual, $2 = warn (opcional, default WARN), $3 = crit (opcional, default CRIT)
  local pct=$1 warn=${2:-$WARN} crit=${3:-$CRIT}
  if   awk "BEGIN{exit !($pct >= $crit)}"; then printf '%s' "$RED"
  elif awk "BEGIN{exit !($pct >= $warn)}"; then printf '%s' "$ORANGE"
  else                                         printf '%s' "$GREEN"
  fi
}

# ── diretório: $HOME vira ~, mantém no máximo 3 segmentos finais ──────────────
tilde='~'
dir="${cwd/#$HOME/$tilde}"
if [ "$(tr -cd '/' <<<"$dir" | wc -c)" -gt 3 ]; then
  dir="…/$(printf '%s' "$dir" | rev | cut -d/ -f1-2 | rev)"
fi

# ── git: UMA chamada devolve branch, divergência e sujeira ───────────────────
git_seg=""
if status=$(git -C "$cwd" status --porcelain=v1 -b -uno 2>/dev/null); then
  head_line=${status%%$'\n'*}
  branch=${head_line#'## '}
  branch=${branch%%...*}
  [ "$branch" = "HEAD (no branch)" ] && branch="detached"

  marks=""
  [ "$status" != "$head_line" ] && marks+="*"                       # working tree sujo
  [[ $head_line =~ ahead\ ([0-9]+) ]] && marks+="↑${BASH_REMATCH[1]}"
  [[ $head_line =~ behind\ ([0-9]+) ]] && marks+="↓${BASH_REMATCH[1]}"

  git_seg=" ${MAGENTA}${branch}${R}${YELLOW}${marks}${R}"
fi

# ── contexto: barra de progresso ─────────────────────────────────────────────
[ -z "$used_pct" ] && [ -n "$total_input" ] && [ -n "$ctx_size" ] && [ "$ctx_size" -gt 0 ] 2>/dev/null \
  && used_pct=$(awk "BEGIN{print ($total_input/$ctx_size)*100}")

ctx_seg=""
if [ -n "$used_pct" ]; then
  pct=$(printf '%.0f' "$used_pct")
  c=$(color_for "$pct" "$CTX_WARN" "$CTX_CRIT")
  filled=$(( (pct + 9) / 10 )); [ "$filled" -gt 10 ] && filled=10
  bar=""
  for ((i = 0; i < 10; i++)); do
    (( i < filled )) && bar+="█" || bar+="░"
  done
  ctx_seg=" ${DIM}ctx${R} ${c}${bar} ${pct}%${R}"
fi

# ── limites de uso ───────────────────────────────────────────────────────────
# Contagem regressiva até o reset, sempre visível: o dado é mais útil justamente
# com uso BAIXO — saber que o reset está perto libera gastar em vez de economizar
# à toa. Fica discreto (cinza) enquanto há folga e acende junto com o percentual
# a partir de WARN, para o bloco inteiro do limite chamar atenção de uma vez.
reset_hint() { # $1 = percentual usado, $2 = epoch do reset
  local pct=$1 epoch=${2%%.*} delta when c=$DIM
  [ -n "$pct" ] && [ -n "$epoch" ] || return
  awk "BEGIN{exit !($pct >= $WARN)}" && c=$(color_for "$pct")

  delta=$(( epoch - $(date +%s) ))
  [ "$delta" -gt 0 ] || return

  if [ "$delta" -ge 86400 ]; then
    when=$(fmt_date "$epoch" '+%d/%m')
    # arredonda para o dia mais próximo: truncar mostraria "4d" faltando 4,99 dias
    printf '%s ↻%dd (%s)%s' "$c" "$(( (delta + 43200) / 86400 ))" "$when" "$R"
  else
    when=$(fmt_date "$epoch" '+%H:%M')
    if [ "$delta" -ge 3600 ]; then
      printf '%s ↻%dh%02dm (%s)%s' "$c" "$(( delta / 3600 ))" "$(( delta % 3600 / 60 ))" "$when" "$R"
    else
      printf '%s ↻%dm (%s)%s' "$c" "$(( (delta + 59) / 60 ))" "$when" "$R"
    fi
  fi
}

fmt_date() { # $1 = epoch, $2 = formato — BSD (macOS) com fallback GNU
  date -r "$1" "$2" 2>/dev/null || date -d "@$1" "$2" 2>/dev/null
}

limits=()
[ -n "$fh_pct" ] && limits+=("$(color_for "$fh_pct")$(printf '5h %.0f%%' "$fh_pct")${R}$(reset_hint "$fh_pct" "$fh_reset")")
[ -n "$sd_pct" ] && limits+=("$(color_for "$sd_pct")$(printf 'wk %.0f%%' "$sd_pct")${R}$(reset_hint "$sd_pct" "$sd_reset")")

# ── monta a linha ────────────────────────────────────────────────────────────
sep="${DIM} │ ${R}"
line="${BLUE}${dir}${R}${git_seg}"
[ -n "$model" ] && line+="${sep}${CYAN}${model}${R}"
[ -n "$ctx_seg" ] && line+="${ctx_seg}"
if [ ${#limits[@]} -gt 0 ]; then
  line+="${sep}${limits[0]}"
  [ ${#limits[@]} -eq 2 ] && line+="${DIM} · ${R}${limits[1]}"
fi

printf '%s' "$line"
