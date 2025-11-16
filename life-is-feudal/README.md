# Life is Feudal: Your Own - Docker Containers for Pterodactyl

This directory contains Docker container definitions for running Life is Feudal: Your Own on Pterodactyl panel.

## Pre-built Images

Both containers are automatically built and published to GitHub Container Registry:

- **MariaDB**: `ghcr.io/lif-x/lif-mariadb:latest`
- **Wine**: `ghcr.io/lif-x/lif-wine:latest`

You can pull and use these images directly:
```bash
docker pull ghcr.io/lif-x/lif-mariadb:latest
docker pull ghcr.io/lif-x/lif-wine:latest
```

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

### Using Pre-built Images

Simply pull the images from GitHub Container Registry:
```bash
docker pull ghcr.io/lif-x/lif-mariadb:latest
docker pull ghcr.io/lif-x/lif-wine:latest
```

### Building Both Images Locally

If you prefer to build the images yourself:

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
    image: ghcr.io/lif-x/lif-mariadb:latest
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
    image: ghcr.io/lif-x/lif-wine:latest
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

### Pre-configured Eggs

Two ready-to-use Pterodactyl eggs are included:

#### 1. Game Server Egg: `egg-life-is-feudal-your-own.json`

This egg configures the Life is Feudal: Your Own game server:
- Uses `ghcr.io/lif-x/lif-wine:latest` Docker image
- Pre-configured environment variables for database connection, server settings, and Wine configuration
- Automatic SteamCMD installation script (App ID: 320850)
- File parsers for `config_local.cs` and `config/world_1.xml`
- Includes 16 configurable variables (server name, max players, database credentials, world type, etc.)

#### 2. MariaDB Egg: `egg-mariadb-d-b10-3.json`

This egg configures the MariaDB 10.3 database server:
- Uses `ghcr.io/lif-x/lif-mariadb:latest` Docker image
- Automatic database initialization
- Custom configuration files (`my.cnf` and `install.my.cnf`) hosted in this repository
- File parser for `.my.cnf` to configure port and bind-address

**To use:**
1. Download both egg JSON files from this repository
2. In your Pterodactyl panel, go to Admin → Nests
3. Import both egg JSON files
4. Create a MariaDB server first using the MariaDB egg
5. Create a game server using the Life is Feudal egg and configure it to connect to your MariaDB server

### Configuration Files

The MariaDB egg uses two configuration files that are automatically downloaded during installation:
- `mariadb/my.cnf` - Runtime MariaDB configuration
- `mariadb/install.my.cnf` - Installation-time MariaDB configuration

Both files are hosted in this repository and referenced in the egg installation script.

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

## Automated Builds

Both containers are automatically built and published via GitHub Actions:

- **MariaDB**: Triggered on changes to `life-is-feudal/mariadb/` directory
- **Wine**: Triggered on changes to `life-is-feudal/wine/` directory

Images are pushed to GitHub Container Registry with the `latest` tag on merges to the `main` branch.

Workflow files:
- `.github/workflows/build-mariadb.yml`
- `.github/workflows/build-wine.yml`

## Support

For issues specific to these Docker containers, please open an issue in this repository.

For Life is Feudal: Your Own server support, refer to the [official documentation](https://lifeisfeudal.gamepedia.com/).

## License

These Dockerfiles are provided as-is for use with Life is Feudal: Your Own and Pterodactyl panel.
