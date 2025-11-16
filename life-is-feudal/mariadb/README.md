# Life is Feudal: Your Own - MariaDB Container

This Docker container provides a MariaDB 10.3 database optimized for Life is Feudal: Your Own game server when running on Pterodactyl.

## Features

- Based on official MariaDB 10.3 image
- Pre-configured for optimal Life is Feudal: Your Own performance
- UTF-8MB4 character set support
- Optimized InnoDB settings for game data
- Health checks included
- Compatible with Pterodactyl panel

## Environment Variables

You can customize the following environment variables:

- `MYSQL_ROOT_PASSWORD`: Root password (default: lifisfeudal)
- `MYSQL_DATABASE`: Default database name (default: lif_gameserver)
- `MYSQL_USER`: Default user (default: lif_user)
- `MYSQL_PASSWORD`: Default user password (default: lif_password)

## Building the Image

```bash
docker build -t lif-mariadb:10.3 .
```

## Running the Container

### Standalone Mode

```bash
docker run -d \
  --name lif-mariadb \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=your_secure_password \
  -e MYSQL_DATABASE=lif_gameserver \
  -e MYSQL_USER=lif_user \
  -e MYSQL_PASSWORD=your_user_password \
  -v lif-data:/var/lib/mysql \
  lif-mariadb:10.3
```

### With Pterodactyl

This image is designed to work with Pterodactyl. Configure your egg to use this image and set the appropriate environment variables through the panel.

## Configuration

The container includes a custom MariaDB configuration file (`my.cnf`) that optimizes:

- Character set (UTF-8MB4)
- Connection pooling
- Buffer sizes
- Query cache
- InnoDB settings

You can override this configuration by mounting your own `my.cnf` file:

```bash
-v /path/to/your/my.cnf:/etc/mysql/conf.d/lif-custom.cnf
```

## Health Check

The container includes a health check that verifies MariaDB is responding to ping commands every 30 seconds.

## Ports

- `3306`: MariaDB server port

## Volumes

- `/var/lib/mysql`: Database data directory

## Notes

- Default credentials are provided for convenience but should be changed in production
- Make sure to persist the `/var/lib/mysql` volume to avoid data loss
- The container may take 20-30 seconds to fully initialize on first run
