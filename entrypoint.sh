#!/bin/sh
set -e

echo "==> Clonando ${GH_OWNER}/${GH_REPO} branch=${GH_BRANCH:-main} ..."

if [ -n "$GH_TOKEN" ]; then
  git clone --depth 1 --branch "${GH_BRANCH:-main}" \
    "https://${GH_TOKEN}@github.com/${GH_OWNER}/${GH_REPO}.git" /tmp/repo
else
  git clone --depth 1 --branch "${GH_BRANCH:-main}" \
    "https://github.com/${GH_OWNER}/${GH_REPO}.git" /tmp/repo
fi

COMMIT=$(git -C /tmp/repo log -1 --format="%h %s")
echo "==> Commit: ${COMMIT}"

# Suporte a subdirectório opcional dentro do repositório
SRC="/tmp/repo"
if [ -n "$GH_SUBDIR" ]; then
  SRC="/tmp/repo/${GH_SUBDIR}"
fi

cp -r "${SRC}/." /usr/share/nginx/html/
rm -rf /tmp/repo

echo "==> Gerando config.js ..."
cat > /usr/share/nginx/html/config.js << EOF
window.APP_CONFIG = {
  ghToken:  "${GH_TOKEN}",
  ghOwner:  "${GH_OWNER}",
  ghRepo:   "${GH_REPO}",
  ghBranch: "${GH_BRANCH:-main}"
};
EOF

echo "==> Pronto. Iniciando nginx..."
exec nginx -g 'daemon off;'
