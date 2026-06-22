#!/bin/bash

GREEN="\e[32m"
CYAN="\e[36m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

clear

# ================= HEADER =================
draw_header() {
  echo -e "${CYAN}"
  echo "╔════════════════════════════════════════════════════════════════════╗"
  echo "║                      UP FORDER GITHUB                              ║"
  echo "║                       SHOT BY GBAO 🔥                              ║"
  echo "╚════════════════════════════════════════════════════════════════════╝"
  echo -e "${RESET}"
}

# ================= LEFT PANEL =================
draw_left() {
  echo -e "${YELLOW}┌──────────── MENU ────────────┐${RESET}"
  echo -e "│ 1. 🚀 Deploy Project         │"
  echo -e "│ 2. 🔄 Refresh System         │"
  echo -e "│ 3. 📊 Git Status             │"
  echo -e "│ 4. 🌿 Branch Info            │"
  echo -e "│ 5. ❌ Exit                   │"
  echo -e "${YELLOW}└──────────────────────────────┘${RESET}"
}

# ================= RIGHT PANEL =================
draw_right() {
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  changes=$(git status --porcelain | wc -l)

  echo -e "${CYAN}┌──────────── SYSTEM INFO ────────────┐${RESET}"
  echo -e "  🌿 Branch   : $branch"
  echo -e "  📁 Repo     : $(basename "$PWD")"
  echo -e "  📦 Changes  : $changes"
  echo -e "  ⚡ Status   : ONLINE"
  echo -e "${CYAN}└──────────────────────────────────────┘${RESET}"
}

# ================= DEPLOY =================
deploy() {
  echo -e "${GREEN}[SYSTEM] Injecting files...${RESET}"
  git add . >/dev/null 2>&1
  sleep 1

  echo -e "${GREEN}[SYSTEM] Committing...${RESET}"
  git commit -m "update" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo -e "${RED}[ERROR] No changes${RESET}"
    return
  fi
  sleep 1

  branch=$(git rev-parse --abbrev-ref HEAD)

  echo -e "${GREEN}[SYSTEM] Pushing to origin/$branch...${RESET}"
  git push origin -force "$branch" >/dev/null 2>&1
  sleep 1

  echo ""
  echo -e "${CYAN}===================================="
  echo -e "     💀 DEPLOY COMPLETE"
  echo -e "     🔥 SHOT BY GBAO"
  echo -e "====================================${RESET}"
}

# ================= MAIN =================
while true; do
  clear
  draw_header
  echo ""

  draw_left
  echo ""
  draw_right

  echo ""
  read -p ">> SELECT COMMAND: " cmd

  case $cmd in
    1) deploy; read -p "Press Enter..." ;;
    2) continue ;;
    3) git status; read -p "Press Enter..." ;;
    4) git branch; read -p "Press Enter..." ;;
    5) echo "Exit..."; break ;;
    *) echo "Invalid"; sleep 1 ;;
  esac
done