# Life is Feudal: Your Own - MariaDB Container
# Based on MariaDB 10.3 for Pterodactyl

FROM mariadb:10.3

LABEL maintainer="LiF-x"
LABEL description="MariaDB 10.3 container optimized for Life is Feudal: Your Own"

# Set environment variables for MariaDB configuration
ENV MYSQL_ROOT_PASSWORD=lifisfeudal
ENV MYSQL_DATABASE=lif_gameserver
ENV MYSQL_USER=lif_user
ENV MYSQL_PASSWORD=lif_password

# Copy custom MariaDB configuration for Life is Feudal
COPY my.cnf /etc/mysql/conf.d/lif-custom.cnf

# Expose MariaDB port
EXPOSE 3306

# Health check to ensure MariaDB is running
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD mysqladmin ping -h localhost -u root -p${MYSQL_ROOT_PASSWORD} || exit 1

# Use default MariaDB entrypoint
CMD ["mysqld"]
