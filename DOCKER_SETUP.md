# 🐳 ConsumeSafe Docker Setup Guide

## Prerequisites

- Docker Desktop installed ([Download](https://www.docker.com/products/docker-desktop))
- Docker Compose (included with Docker Desktop)
- At least 4GB of free RAM
- Ports 3306, 8082, 8083 available

## Quick Start

### Windows (PowerShell)
```powershell
cd c:\Users\khouloud\Desktop\ConsumeSafe
.\start-docker.ps1
```

### Linux / macOS (Bash)
```bash
cd ~/ConsumeSafe
chmod +x start-docker.sh
./start-docker.sh
```

### Manual Start (All Platforms)
```bash
cd ConsumeSafe
docker-compose up -d
```

## Services

### 1. MySQL Database
- **Container Name**: consumesafe-mysql
- **Host**: localhost:3306
- **Database**: consumesafe
- **Username**: consumesafe
- **Password**: consumesafe123
- **Root Password**: rootpassword

### 2. ConsumeSafe Application
- **Container Name**: consumesafe-app
- **URL**: http://localhost:8082
- **API Base**: http://localhost:8082/api

### 3. PhpMyAdmin (Optional)
- **Container Name**: consumesafe-phpmyadmin
- **URL**: http://localhost:8083
- **Username**: consumesafe
- **Password**: consumesafe123

## Useful Commands

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f mysql
docker-compose logs -f app
```

### Access MySQL CLI
```bash
docker exec -it consumesafe-mysql mysql -u consumesafe -p
# Password: consumesafe123
```

### Execute SQL Commands
```bash
docker exec -i consumesafe-mysql mysql -u consumesafe -pconsumeafe123 consumesafe < backup.sql
```

### View Database Status
```bash
docker exec consumesafe-mysql mysqladmin -u consumesafe -pconsumeafe123 status
```

### Restart Services
```bash
docker-compose restart
```

### Stop Services
```bash
docker-compose down
```

### Remove All Data (Reset)
```bash
docker-compose down -v
```

### Build Docker Image
```bash
docker-compose build --no-cache
```

### Check Container Status
```bash
docker-compose ps
```

## Database Management

### Using PhpMyAdmin
1. Open http://localhost:8083
2. Server: mysql
3. Username: consumesafe
4. Password: consumesafe123

### Using MySQL CLI
```bash
docker exec -it consumesafe-mysql mysql -u consumesafe -pconsumeafe123
```

### Backup Database
```bash
docker exec consumesafe-mysql mysqldump -u consumesafe -pconsumeafe123 consumesafe > backup.sql
```

### Restore Database
```bash
docker exec -i consumesafe-mysql mysql -u consumesafe -pconsumeafe123 consumesafe < backup.sql
```

## Troubleshooting

### MySQL Connection Refused
```bash
# Check if MySQL is running
docker-compose ps

# Check MySQL logs
docker-compose logs mysql

# Restart MySQL
docker-compose restart mysql
```

### Application Cannot Connect to Database
```bash
# Check environment variables
docker-compose config

# View application logs
docker-compose logs app

# Verify database is running
docker exec consumesafe-mysql mysqladmin -u root -prootpassword ping
```

### Port Already in Use
```bash
# Change ports in docker-compose.yml
# Example: Change 3306:3306 to 3307:3306

# Or kill existing process
# Windows:
netstat -ano | findstr :3306
taskkill /PID <PID> /F

# Linux/macOS:
lsof -i :3306
kill -9 <PID>
```

### Out of Memory
```bash
# Increase Docker Desktop RAM allocation
# Docker Desktop → Preferences → Resources → Memory (set to 4GB+)
```

## Environment Variables

Edit `.env` file to customize:

```env
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_DATABASE=consumesafe
MYSQL_USER=consumesafe
MYSQL_PASSWORD=consumesafe123
SPRING_PROFILES_ACTIVE=prod
SERVER_PORT=8082
```

## Health Checks

### MySQL Health
```bash
docker exec consumesafe-mysql mysqladmin -u root -prootpassword ping
```

### Application Health
```bash
curl http://localhost:8082/api/products/health
```

## Performance Optimization

### MySQL Optimization
```bash
# Run optimization
docker exec consumesafe-mysql mysql -u consumesafe -pconsumeafe123 consumesafe -e "OPTIMIZE TABLE products, alternatives;"
```

### Check Slow Queries
```bash
docker exec consumesafe-mysql mysql -u consumesafe -pconsumeafe123 consumesafe -e "SELECT * FROM mysql.slow_log;"
```

## Scaling

### Increase Resources
Edit `docker-compose.yml`:
```yaml
deploy:
  resources:
    limits:
      cpus: "2.0"      # Increase CPU
      memory: 2048M    # Increase RAM
```

## Security

### Change Default Passwords
1. Edit `.env`
2. Update Docker Compose environment variables
3. Run `docker-compose down -v` to reset
4. Run `docker-compose up -d`

### Enable SSL/TLS
```bash
# Update MySQL connection string in docker-compose.yml
SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/consumesafe?useSSL=true
```

## Monitoring

### View Real-time Stats
```bash
docker stats consumesafe-mysql consumesafe-app
```

### Check Disk Usage
```bash
docker system df
```

### Clean Up Unused Resources
```bash
docker system prune -a
```

## Production Deployment

### Build for Production
```bash
docker build -t consumesafe:1.0.0-prod .
```

### Use Production Compose File
```bash
docker-compose -f docker-compose.prod.yml up -d
```

### Deploy to Docker Hub
```bash
docker tag consumesafe:1.0.0 yourusername/consumesafe:1.0.0
docker push yourusername/consumesafe:1.0.0
```

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Spring Boot Docker Guide](https://spring.io/guides/topicals/spring-boot-docker/)
