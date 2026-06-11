#!/bin/sh
# Gera config.js com as variáveis de ambiente injetadas pelo Docker
cat > /usr/share/nginx/html/config.js << EOF
window.APP_CONFIG = {
  ghToken:  "${GH_TOKEN}",
  ghOwner:  "${GH_OWNER}",
  ghRepo:   "${GH_REPO}",
  ghBranch: "${GH_BRANCH:-main}"
};
EOF

echo "config.js gerado com sucesso."
exec nginx -g 'daemon off;'
