#!/bin/bash

# ================= COLORS =================
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

# ================= SPINNER ANIMATION =================
spinner() {
  pid=$1
  msg=$2

  frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

  i=0
  while kill -0 $pid 2>/dev/null; do
    frame=${frames[$((i % 10))]}
    printf "\r${CYAN}${msg} ${frame} ${RESET}"
    sleep 0.08
    ((i++))
  done

  printf "\r${GREEN}${msg} ✔${RESET}\n"
}

# ================= UI =================
clear

echo -e "${BLUE}"
echo "=========================================="
echo "   🚀 GIT ULTRA PRO MAX DEPLOY TOOL"
echo "=========================================="
echo -e "${RESET}"

# ================= CLEAN JUNK FILES =================
echo -e "${YELLOW}🧹 Cleaning junk files...${RESET}"
find . -name "*Zone.Identifier" -type f -delete 2>/dev/null

# ================= ADD =================
(git add .) &
spinner $! "📦 Adding files"

# ================= COMMIT =================
git commit -m "update" >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "${YELLOW}⚠ No changes to commit${RESET}"
  exit 0
fi

echo -e "${GREEN}💬 Commit done${RESET}"

# ================= BRANCH =================
branch=$(git rev-parse --abbrev-ref HEAD)
echo -e "${CYAN}🌿 Branch: $branch${RESET}"

# ================= PUSH =================
(git push origin --force "$branch") &
spinner $! "🚀 Pushing to origin"

if [ $? -ne 0 ]; then
  echo -e "${RED}❌ Push failed${RESET}"
  exit 1
fi

# ================= SUCCESS ANIMATION =================
echo ""
echo -e "${GREEN}"
echo "🎉 DEPLOY SUCCESSFUL"
echo -e "${RESET}"

# fake mini animation
for i in {1..3}; do
  echo -e "${CYAN}✨ Deploying${RESET}"
  sleep 0.2
  echo -e "${CYAN}🚀 Deploying.${RESET}"
  sleep 0.2
  echo -e "${CYAN}🚀 Deploying..${RESET}"
  sleep 0.2
  echo -e "${CYAN}🚀 Deploying...${RESET}"
done

# ================= FINAL =================
echo ""
echo -e "${BLUE}=========================================="
echo -e "🌍 WEBSITE UPDATE IN 1–3 MINUTES"
echo -e "🔥 ULTRA PRO MAX FINISHED"
echo -e "=========================================="
echo -e "${RESET}"