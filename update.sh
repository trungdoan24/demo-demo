#!/bin/bash

# ================= COLORS =================
GREEN="\e[32m"
CYAN="\e[36m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# ================= FULL SCREEN CLEAR =================
clear
printf '\e[8;40;120t'  # resize terminal (nếu terminal hỗ trợ)

# ================= MATRIX BACKGROUND =================
matrix_bg() {
  for i in {1..20}; do
    line=""
    for j in {1..120}; do
      rand=$((RANDOM % 2))
      line+="$rand"
    done
    echo -e "${GREEN}${line}${RESET}"
  done
}

# ================= HEADER =================
header() {
  clear
  echo -e "${CYAN}"
  echo "╔════════════════════════════════════════════════════════════════════╗"
  echo "║                         UPLOAD FILE                                ║"
  echo "║                    SYSTEM STATUS: ONLIN E                          ║"
  echo "║                    MODE: FULL CONTROL PA NEL                       ║"
  echo "╚════════════════════════════════════════════════════════════════════╝"
  echo -e "${RESET}"
}

# ================= STATUS PANEL =================
status_panel() {
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  echo -e "${YELLOW}┌── SYSTEM DASHBOARD ───────────────────────────────┐${RESET}"
  echo -e "  🌿 Branch      : ${GREEN}$branch${RESET}"
  echo -e "  📁 Repo        : $(basename "$PWD")"
  echo -e "  ⚡ Mode        : DEPLOY ACTIVE"
  echo -e "  🧠 AI Status   : READY"
  echo -e "${YELLOW}└───────────────────────────────────────────────────┘${RESET}"
}

# ================= DEPLOY SEQUENCE =================
deploy() {
  echo ""
  echo -e "${CYAN}[1] Injecting files...${RESET}"
  git add . >/dev/null 2>&1
  sleep 1

  echo -e "${CYAN}[2] Committing system...${RESET}"
  git commit -m "update" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo -e "${RED}[ERROR] No changes detected${RESET}"
    return
  fi
  sleep 1

  branch=$(git rev-parse --abbrev-ref HEAD)

  echo -e "${CYAN}[3] Pushing to origin/$branch...${RESET}"
  git push origin --force "$branch" >/dev/null 2>&1
  sleep 1

  echo ""
  echo -e "${GREEN}======================================"
  echo "       DEPLOY SUCCESSFUL"
  echo -e "======================================${RESET}"
}

# ================= MAIN LOOP =================
while true; do
  header
  matrix_bg
  status_panel

  echo ""
  echo -e "${CYAN}COMMANDS:${RESET}"
  echo "  [1] Deploy project"
  echo "  [2] Refresh system"
  echo "  [3] Exit OS"
  echo ""

  read -p ">> " cmd

  case $cmd in
    1)
      deploy
      read -p "Press Enter..."
      ;;
    2)
      continue
      ;;
    3)
      echo "Shutting down..."
      break
      ;;
    *)
      echo "Unknown command..."
      sleep 1
      ;;
  esac
done