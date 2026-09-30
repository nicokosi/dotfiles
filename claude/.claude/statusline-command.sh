#!/usr/bin/env bash
# Claude Code status line, styled after the user's fish "tide" prompt.
# Colors/glyphs mirror the tide_* universal variables in
# ~/.config/fish/fish_variables. Tide's left prompt is: vi_mode, pwd, git
# (vi_mode is meaningless here, so only pwd and git are rendered).

input=$(cat)
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // empty' 2>/dev/null)
[ -n "$cwd" ] || cwd=$PWD

# --- tide palette -----------------------------------------------------------
PWD_BG='52;101;164'       # tide_pwd_bg_color            3465A4
PWD_FG='228;228;228'      # tide_pwd_color_dirs          E4E4E4
GIT_FG='0;0;0'            # tide_git_color_branch        000000
GIT_BG_CLEAN='78;154;6'   # tide_git_bg_color            4E9A06
GIT_BG_DIRTY='196;160;0'  # tide_git_bg_color_unstable   C4A000
GIT_BG_URGENT='204;0;0'   # tide_git_bg_color_urgent     CC0000
SEP=$''             # tide_left_prompt_separator_diff_color
SUFFIX=$''          # tide_left_prompt_suffix
RESET=$'\033[0m'

fg() { printf '\033[38;2;%sm' "$1"; }
bg() { printf '\033[48;2;%sm' "$1"; }

# --- pwd item (home-relative, like tide) ------------------------------------
case "$cwd" in
  "$HOME")   disp='~' ;;
  "$HOME"/*) disp="~${cwd#"$HOME"}" ;;
  *)         disp="$cwd" ;;
esac

# --- git item ---------------------------------------------------------------
branch=$(git -C "$cwd" symbolic-ref --quiet --short HEAD 2>/dev/null) \
  || branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

git_bg=""
if [ -n "$branch" ]; then
  # tide_git_truncation_length = 24
  [ ${#branch} -gt 24 ] && branch="${branch:0:23}…"

  git_bg=$GIT_BG_CLEAN
  marks=""
  status=$(git -C "$cwd" status --porcelain 2>/dev/null)
  if [ -n "$status" ]; then
    case "$status" in *$'\n'UU*|UU*|*$'\n'AA*|AA*|*$'\n'DD*|DD*) git_bg=$GIT_BG_URGENT ;;
                      *) git_bg=$GIT_BG_DIRTY ;; esac
    printf '%s\n' "$status" | grep -q '^.[MADRC]' && marks="$marks!"   # unstaged
    printf '%s\n' "$status" | grep -q '^[MADRC]'  && marks="$marks+"   # staged
    printf '%s\n' "$status" | grep -q '^??'       && marks="$marks?"   # untracked
  fi
  [ -n "$marks" ] && branch="$branch $marks"
fi

# --- render -----------------------------------------------------------------
bg "$PWD_BG"; fg "$PWD_FG"; printf ' %s ' "$disp"

if [ -n "$git_bg" ]; then
  bg "$git_bg"; fg "$PWD_BG"; printf '%s' "$SEP"       # slant, prev bg -> git bg
  fg "$GIT_FG"; printf ' %s ' "$branch"
  printf '%s' "$RESET"; fg "$git_bg"; printf '%s' "$SUFFIX"
else
  printf '%s' "$RESET"; fg "$PWD_BG"; printf '%s' "$SUFFIX"
fi
printf '%s' "$RESET"

# --- context window usage (plain grey text after the prompt) ----------------
ctx=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)
if [ -n "$ctx" ]; then
  ctx=$(printf '%.0f' "$ctx")
  ctx_color='136;138;133'
  [ "$ctx" -gt 80 ] && ctx_color='245;121;0'  # Tango orange F57900
  fg "$ctx_color"; printf ' ctx %s%%' "$ctx"; printf '%s' "$RESET"
fi
