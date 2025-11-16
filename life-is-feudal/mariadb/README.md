# Life is Feudal: Your Own - MariaDB Container

This Docker container provides a MariaDB database for Life is Feudal: Your Own game server when running on Pterodactyl.

## Features

- Based on Debian Bookworm with MariaDB server
- Lightweight and efficient
- Custom entrypoint for Pterodactyl integration
- Automatic MySQL upgrade on startup
- Non-root user for security
- Compatible with Pterodactyl panel

## Environment Variables

The container uses the following environment variables:

- `STARTUP`: The startup command for the MariaDB server (provided by Pterodactyl)
- `INTERNAL_IP`: Automatically set to the container's internal IP address
- `USER_ID`, `GROUP_ID`, `USER_NAME`: User information for NSS wrapper

## Building the Image

```bash
cd life-is-feudal
docker build -f mariadb/Dockerfile -t lif-mariadb:latest .
```

## Running the Container

### Standalone Mode

```bash
docker run -d \
  --name lif-mariadb \
  -p 3306:3306 \
  -e STARTUP="/usr/sbin/mysqld" \
  -v lif-data:/home/container \
  lif-mariadb:latest
```

### With Pterodactyl

This image is designed to work with Pterodactyl. Configure your egg to use this image and set the appropriate environment variables through the panel.

## How It Works

The container:

1. Starts a temporary MariaDB instance in the background
2. Runs `mysql_upgrade` to ensure database compatibility
3. Stops the temporary instance
4. Executes the command specified in the `STARTUP` environment variable

This ensures the database is properly initialized before your game server starts.

## User

The container runs as the `container` user (non-root) for security. All files should be owned by this user.

## Ports

- `3306`: MariaDB server port

## Volumes

- `/home/container`: Container working directory and data storage

## Notes

- The container automatically runs `mysql_upgrade` on startup
- Make sure to persist the `/home/container` volume to avoid data loss
- The `STARTUP` environment variable must be set for the container to function properly
- Designed for use with Pterodactyl panel which handles startup commands and environment variables
