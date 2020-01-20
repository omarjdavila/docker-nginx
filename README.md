### ENV:

* **WORKDIR**
Docker workdir. Default: `/www`

### VOLUME:
>   nginx config:
>   - ```/nginx/config:/etc/nginx:ro```
>   - ```/php/socket:/var/run/php```

### PORT:
- **Expose** `80/tcp`

### docker-compose.yml (example):
```yml
php:
    name: nginx
    hostname: nginx
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://nginx/status/fpm"]
    image: omardavila64/nginx
    restart: unless-stopped
    volumes:
      - ./:/www
      - ./nginx/config:/etc/nginx:ro
      - ./php/socket:/var/run/php
```