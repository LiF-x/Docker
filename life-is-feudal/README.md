# Life is Feudal: Your Own - Docker Containers for Pterodactyl

This directory contains Docker container definitions for running Life is Feudal: Your Own on Pterodactyl panel.

## Containers

### 1. MariaDB Container
Located in `mariadb/`

A MariaDB database container for Life is Feudal: Your Own.

**Key Features:**
- Based on Debian Bookworm with MariaDB server
- Lightweight and efficient
- Compatible with Pterodactyl panel
- Custom entrypoint for game server integration

**Building:**
```bash
cd life-is-feudal
docker build -f mariadb/Dockerfile -t lif-mariadb:latest .
```

See [mariadb/README.md](mariadb/README.md) for detailed documentation.

### 2. Wine Game Server Container
Located in `wine/`

A Wine-based container for running the Life is Feudal: Your Own dedicated server.

**Key Features:**
- Wine from Debian Bullseye repositories
- Xvfb for headless operation
- Support for additional Windows components
- Non-root user for security
- Pre-configured Wine prefix

**Building:**
```bash
cd life-is-feudal
docker build -f wine/Dockerfile -t lif-wine:latest .
```

See [wine/README.md](wine/README.md) for detailed documentation.

## Quick Start

### Building Both Images

```bash
# Build from the life-is-feudal directory
cd life-is-feudal

# Build MariaDB container
docker build -f mariadb/Dockerfile -t lif-mariadb:latest .

# Build Wine container
docker build -f wine/Dockerfile -t lif-wine:latest .
```

### Running with Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  database:
    image: lif-mariadb:latest
    container_name: lif-database
    environment:
      MYSQL_ROOT_PASSWORD: your_secure_root_password
      MYSQL_DATABASE: lif_gameserver
      MYSQL_USER: lif_user
      MYSQL_PASSWORD: your_secure_user_password
    volumes:
      - lif-db-data:/var/lib/mysql
    ports:
      - "3306:3306"
    restart: unless-stopped
    networks:
      - lif-network

  gameserver:
    image: lif-wine:latest
    container_name: lif-gameserver
    depends_on:
      - database
    volumes:
      - lif-server-data:/home/container
    ports:
      - "28000:28000/udp"
      - "28100:28100/tcp"
    command: wine /home/container/cm_server.exe
    restart: unless-stopped
    networks:
      - lif-network

volumes:
  lif-db-data:
  lif-server-data:

networks:
  lif-network:
    driver: bridge
```

Then run:
```bash
docker-compose up -d
```

## Using with Pterodactyl

These containers are designed to integrate with Pterodactyl panel:

1. **Upload the images** to your container registry or build them on your Pterodactyl nodes
2. **Create Pterodactyl eggs** that reference these images
3. **Configure the eggs** with appropriate startup commands and environment variables
4. **Deploy servers** through the Pterodactyl panel

### Recommended Egg Configuration

#### MariaDB Egg
- **Docker Image:** `lif-mariadb:latest`
- **Startup Command:** Configured via STARTUP environment variable
- **Environment Variables:** As needed by your server configuration

#### Game Server Egg
- **Docker Image:** `lif-wine:latest`
- **Startup Command:** `wine /home/container/cm_server.exe` (adjust based on your server executable)
- **Environment Variables:** As needed by your server configuration

## Architecture

```
Life is Feudal: Your Own Setup
├── MariaDB Container (Database)
│   ├── MariaDB 10.3
│   ├── Custom configuration
│   └── UTF-8MB4 support
│
└── Wine Container (Game Server)
    ├── Debian Bullseye
    ├── Wine (latest stable)
    ├── Xvfb (headless display)
    ├── Server executable
    └── Game data
```

## Requirements

- Docker Engine 20.10 or later
- Sufficient RAM (minimum 2GB for game server, 256MB for database)
- SSD storage recommended for better performance
- Network ports available (28000/udp, 28100/tcp, 3306/tcp)

## Port Reference

| Service | Port | Protocol | Purpose |
|---------|------|----------|---------|
| MariaDB | 3306 | TCP | Database connections |
| Game Server | 28000 | UDP | Game traffic |
| Query/RCON | 28100 | TCP | Server queries/management |

## Support

For issues specific to these Docker containers, please open an issue in this repository.

For Life is Feudal: Your Own server support, refer to the [official documentation](https://lifeisfeudal.gamepedia.com/).

## License

These Dockerfiles are provided as-is for use with Life is Feudal: Your Own and Pterodactyl panel.
