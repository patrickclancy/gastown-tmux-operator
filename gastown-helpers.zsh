gtops() {
  local session="${1:-gastown-ops}"
  local rig="${2:-}"
  gastown-ops "$session" "$rig"
}

gtops_attach() {
  if [ -n "${TMUX:-}" ]; then
    echo "Already inside tmux. Use Ctrl+b w or Ctrl+b s instead."
  else
    tmux attach -t gastown-ops
  fi
}

gtmayor() {
  gt mayor attach
}

gtown_down() {
  gt down
}

gtown_down_all() {
  gt down --all
}

gtls() {
  tmux ls
}
