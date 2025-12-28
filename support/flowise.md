


```bash
git clone --recursive https://github.com/FlowiseAI/Flowise
cd Flowise
cd docker
cp .env.example .env

# Edit .env .
# ATTENTION: If port override does not work, then change port to 3510 .
! kwrite .env && exit

echo '
name: flowise
services:
  flowise:
    ports: !override
      - "3510:3000"
    volumes:
      - C:/core/data/flowise:/root/.flowise
' > docker-compose.override.yml

docker compose up -d

```



# Reference

https://docs.flowiseai.com/getting-started

https://github.com/FlowiseAI/Flowise
