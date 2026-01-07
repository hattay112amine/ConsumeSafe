#!/bin/bash

# ============================================================
# ConsumeSafe Docker Startup Script
# ============================================================

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║       🛡️ ConsumeSafe Docker Startup Script 🛡️         ║"
echo "╚════════════════════════════════════════════════════════╝"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker daemon is not running. Please start Docker.${NC}"
    exit 1
fi

echo -e "${BLUE}✓ Docker is running${NC}"

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed. Please install Docker Compose.${NC}"
    exit 1
fi

echo -e "${BLUE}✓ Docker Compose is installed${NC}"

# Stop existing containers if running
echo -e "\n${YELLOW}Stopping existing containers...${NC}"
docker-compose down 2>/dev/null || true

# Build the application
echo -e "\n${YELLOW}Building ConsumeSafe application...${NC}"
echo "This may take a few minutes on first run..."
docker-compose build --no-cache

# Start the containers
echo -e "\n${YELLOW}Starting Docker containers...${NC}"
docker-compose up -d

# Wait for services to be ready
echo -e "\n${YELLOW}Waiting for services to be ready...${NC}"
sleep 10

# Check if MySQL is running
if docker exec consumesafe-mysql mysqladmin ping -h localhost -u root -prootpassword > /dev/null 2>&1; then
    echo -e "${GREEN}✓ MySQL is running${NC}"
else
    echo -e "${RED}✗ MySQL failed to start${NC}"
    docker-compose logs mysql
    exit 1
fi

# Check if Application is running
if docker exec consumesafe-app curl -f http://localhost:8082/api/products/health > /dev/null 2>&1; then
    echo -e "${GREEN}✓ ConsumeSafe Application is running${NC}"
else
    echo -e "${YELLOW}⏳ Application is starting, please wait...${NC}"
    sleep 10
fi

# Display service URLs
echo -e "\n${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║        🎉 ConsumeSafe Services Started Successfully 🎉 ║${NC}"
echo -e "${GREEN}╠════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║${NC}"
echo -e "${BLUE}  🌐 Web Application:${NC}"
echo -e "     http://localhost:8082"
echo -e ""
echo -e "${BLUE}  📊 PhpMyAdmin (Database Manager):${NC}"
echo -e "     http://localhost:8083"
echo -e "     Username: consumesafe"
echo -e "     Password: consumesafe123"
echo -e ""
echo -e "${BLUE}  💾 MySQL Connection:${NC}"
echo -e "     Host: localhost"
echo -e "     Port: 3306"
echo -e "     Database: consumesafe"
echo -e "     User: consumesafe"
echo -e "     Password: consumesafe123"
echo -e ""
echo -e "${BLUE}  📡 API Endpoints:${NC}"
echo -e "     Check Product: GET http://localhost:8082/api/products/check?name=..."
echo -e "     Boycotted List: GET http://localhost:8082/api/products/boycotted"
echo -e "     Tunisian List: GET http://localhost:8082/api/products/tunisian"
echo -e ""
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}╠════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}  Useful Docker Commands:${NC}"
echo -e ""
echo -e "     View logs:     docker-compose logs -f"
echo -e "     Stop services: docker-compose down"
echo -e "     MySQL shell:   docker exec -it consumesafe-mysql mysql -u consumesafe -p"
echo -e "     App shell:     docker exec -it consumesafe-app /bin/sh"
echo -e ""
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${YELLOW}📌 To view logs: docker-compose logs -f${NC}"
echo -e "${YELLOW}📌 To stop: docker-compose down${NC}"
