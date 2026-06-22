#!/bin/bash

# ================= COLORS =================
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

# ================= SPINNER =================
spinner() {
  pid=$1
  msg=$2
  spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

  i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(( (i+1) %10 ))
    printf "\r${CYAN}${msg} ${spin:$i:1}${RESET}"
    sleep 0.1
  done
  printf "\r${GREEN}${msg} ✔${RESET}\n"
}

# ================= UI =================
clear

echo -e "${BLUE}"
echo "=========================================="
echo "     🚀 GIT DEPLOY WEB PRO - ULTRA"
echo "=========================================="
echo -e "${RESET}"

# ================= ADD =================
(git add .) &
spinner $! "📦 Adding files"

# ================= COMMIT =================
git commit -m "update"
if [ $? -ne 0 ]; then
  echo -e "${YELLOW}⚠ Không có thay đổi để commit${RESET}"
  exit 0
fi

echo -e "${GREEN}💬 Commit done${RESET}"

# ================= BRANCH AUTO =================
branch=$(git rev-parse --abbrev-ref HEAD)
echo -e "${CYAN}🌿 Current branch: $branch${RESET}"

# ================= PUSH =================
(git push origin --force "$branch") &
spinner $! "🚀 Pushing to origin"

if [ $? -ne 0 ]; then
  echo -e "${RED}❌ Push failed${RESET}"
  exit 1
fi

echo -e "${GREEN}✔ Push success${RESET}"

# ================= GUESS GITHUB PAGES =================
echo ""
echo -e "${YELLOW}🌐 Checking deploy target...${RESET}"

if [ -d "docs" ]; then
  echo -e "${GREEN}📁 Detected /docs deploy folder${RESET}"
else
  echo -e "${GREEN}📁 Using root deploy${RESET}"
fi

# ================= DONE =================
echo ""
echo -e "${BLUE}=========================================="
echo -e "🎉 DEPLOY SUCCESSFUL"
echo -e "🌍 Website will update in 1-3 minutes"
echo -e "=========================================="
echo -e "${RESET}"