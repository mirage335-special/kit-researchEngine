







mkdir -p /cygdrive/c/core/data/kokoro-web

docker run -d -p 127.0.0.1:3300:3000 -e KW_SECRET_API_KEY=#################################### --add-host=host.docker.internal:host-gateway -v 'C:\core\data\'kokoro-web:/app/backend/data --name kokoro-web --restart always ghcr.io/eduardolat/kokoro-web:latest















# Reference

https://docs.openwebui.com/features/audio/text-to-speech/kokoro-web-integration/#:~:text=Kokoro%20Web%20,Open%20WebUI%20to%20enhance






