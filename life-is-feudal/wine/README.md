# Life is Feudal: Your Own - Wine Game Server Container

This Docker container provides a Wine environment optimized for running the Life is Feudal: Your Own dedicated server on Pterodactyl.

## Features

- Based on Debian Bullseye with latest stable Wine
- Xvfb for headless operation
- Pre-configured Wine prefix
- Required dependencies for Life is Feudal: Your Own
- Support for additional Windows components for additional Windows components
- Compatible with Pterodactyl panel
- Non-root user for security

## Building the Image

```bash
docker build -t lif-wine:latest .
```

## Running the Container

### Standalone Mode

```bash
docker run -d \
  --name lif-server \
  -p 28000:28000/udp \
  -p 28100:28100/tcp \
  -v lif-server:/home/container \
  lif-wine:latest \
  wine /home/container/cm_server.exe
```

### With Pterodactyl

This image is designed to work with Pterodactyl. The panel will handle:
- Volume mounting
- Port mapping
- Startup command execution
- Environment variable injection

## Environment Variables

- `WINEPREFIX`: Wine prefix location (default: /home/container/.wine)
- `WINEARCH`: Wine architecture (default: win64)
- `WINEDEBUG`: Wine debug level (default: -all for no debug output)
- `DISPLAY`: X display for Xvfb (default: :99)

## Ports

- `28000/udp`: Game server port (default)
- `28100/tcp`: Query/RCON port (default)

Note: Life is Feudal server ports may be configurable in server settings.

## Volumes

- `/home/container`: Game server files and data

## Server Installation

1. Mount your game server files to `/home/container`
2. Ensure the server executable (typically `cm_server.exe`) is present
3. Configure your server settings in the appropriate configuration files
4. Start the container with the server executable as the command

## Additional Windows Components

If you need to install additional Windows components (like Visual C++ runtimes), you can use Wine's built-in functionality or manually install winetricks if needed.

## User

The container runs as the `container` user (non-root) for security. All files should be owned by this user (UID 1000).

## Troubleshooting

### Wine Prefix Issues

If you encounter Wine prefix corruption, remove the `.wine` directory and restart the container to reinitialize.

### Missing Dependencies

If the server fails to start due to missing DLLs, you may need to install additional Windows components manually or use Wine's built-in tools.

### Display Issues

The container uses Xvfb for headless operation. If you encounter display-related errors, ensure Xvfb is running (it starts automatically via the entrypoint).

## Performance Tips

- Allocate sufficient RAM to the container (minimum 2GB recommended)
- Use SSD storage for better I/O performance
- Ensure the host has adequate CPU resources (2+ cores recommended)

## Security Notes

- The container runs as a non-root user
- Change default passwords if using the MariaDB container
- Restrict network access as needed using firewall rules
- Keep the Wine version updated for security patches

## Compatibility

This container is tested with:
- Life is Feudal: Your Own dedicated server
- Pterodactyl Panel v1.x
- Docker Engine 20.10+

## Additional Resources

- [Life is Feudal Wiki](https://lifeisfeudal.gamepedia.com/)
- [Pterodactyl Documentation](https://pterodactyl.io/panel/1.0/getting_started.html)
- [Wine Documentation](https://www.winehq.org/documentation)
