# ============================================================
# ConsumeSafe Docker Startup Script for Windows
# ============================================================

Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║       🛡️ ConsumeSafe Docker Startup Script 🛡️         ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

# Check if Docker is installed
try {
    $dockerVersion = docker --version
    Write-Host "✓ Docker is installed: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not installed. Please install Docker Desktop for Windows." -ForegroundColor Red
    exit 1
}

# Check if Docker is running
try {
    $dockerInfo = docker info
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

# Stop existing containers
Write-Host "`nStopping existing containers..." -ForegroundColor Yellow
docker-compose down 2>$null

# Build the application
Write-Host "`nBuilding ConsumeSafe application..." -ForegroundColor Yellow
Write-Host "This may take a few minutes on first run..." -ForegroundColor Yellow
docker-compose build --no-cache

# Start containers
Write-Host "`nStarting Docker containers..." -ForegroundColor Yellow
docker-compose up -d

# Wait for services
Write-Host "`nWaiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Check MySQL
Write-Host "Checking MySQL status..." -ForegroundColor Yellow
try {
    docker exec consumesafe-mysql mysqladmin ping -h localhost -u root -prootpassword
    Write-Host "✓ MySQL is running" -ForegroundColor Green
} catch {
    Write-Host "✗ MySQL failed to start" -ForegroundColor Red
    docker-compose logs mysql
    exit 1
}

# Display service URLs
Write-Host "`n" -ForegroundColor Green
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   🎉 ConsumeSafe Services Started Successfully! 🎉    ║" -ForegroundColor Green
Write-Host "╠════════════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "║" -ForegroundColor Green

Write-Host "  🌐 Web Application:" -ForegroundColor Cyan
Write-Host "     http://localhost:8082" -ForegroundColor White

Write-Host "`n  📊 PhpMyAdmin (Database Manager):" -ForegroundColor Cyan
Write-Host "     http://localhost:8083" -ForegroundColor White
Write-Host "     Username: consumesafe" -ForegroundColor White
Write-Host "     Password: consumesafe123" -ForegroundColor White

Write-Host "`n  💾 MySQL Connection:" -ForegroundColor Cyan
Write-Host "     Host: localhost" -ForegroundColor White
Write-Host "     Port: 3306" -ForegroundColor White
Write-Host "     Database: consumesafe" -ForegroundColor White
Write-Host "     User: consumesafe" -ForegroundColor White
Write-Host "     Password: consumesafe123" -ForegroundColor White

Write-Host "`n  📡 API Endpoints:" -ForegroundColor Cyan
Write-Host "     Check Product: GET http://localhost:8082/api/products/check?name=..." -ForegroundColor White
Write-Host "     Boycotted List: GET http://localhost:8082/api/products/boycotted" -ForegroundColor White
Write-Host "     Tunisian List: GET http://localhost:8082/api/products/tunisian" -ForegroundColor White

Write-Host "`n║" -ForegroundColor Green
Write-Host "╠════════════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "  Useful Docker Commands:" -ForegroundColor Cyan
Write-Host "`n     View logs:     docker-compose logs -f" -ForegroundColor White
Write-Host "     Stop services: docker-compose down" -ForegroundColor White
Write-Host "     MySQL shell:   docker exec -it consumesafe-mysql mysql -u consumesafe -p" -ForegroundColor White
Write-Host "     App logs:      docker-compose logs -f app" -ForegroundColor White

Write-Host "`n╚════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`n📌 To view logs: docker-compose logs -f" -ForegroundColor Yellow
Write-Host "📌 To stop: docker-compose down" -ForegroundColor Yellow
