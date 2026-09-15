#!/bin/bash
# Publica o sistema: carimba a versão, envia para o GitHub (Pages) e para o Netlify.
# Uso: ./publicar.sh "mensagem do commit"
set -e
cd "$(dirname "$0")"

MENSAGEM="${1:-chore: publicar atualização}"
CARIMBO="$(date -u '+%Y-%m-%d %H:%M')"

# o carimbo é o que faz o sistema avisar quem está com a página em cache
python3 - "$CARIMBO" <<'PY'
import io, re, sys
p = 'index.html'
s = io.open(p, encoding='utf-8').read()
s = re.sub(r'name="versao-app" content="[^"]+"',
           'name="versao-app" content="%s"' % sys.argv[1], s, count=1)
io.open(p, 'w', encoding='utf-8').write(s)
PY
echo "versão: $CARIMBO"

git add -A
git commit -m "$MENSAGEM" || echo "(nada novo para commitar)"
git push origin main
echo "→ GitHub Pages: https://elizabeth-silvano-ca.github.io/resgate-animais/ (leva alguns minutos)"

netlify deploy --prod --dir . --site f4249f01-7acd-4e82-a716-0effea32bf86
echo "→ Netlify: https://resgate-animais.netlify.app (já no ar)"
