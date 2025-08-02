#!/bin/bash

echo "🚀 Notification System POC - Docker Deployment"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if Docker Compose is available
if ! docker-compose --version > /dev/null 2>&1; then
    print_error "Docker Compose is not installed. Please install Docker Compose and try again."
    exit 1
fi

# Function to deploy development environment
deploy_dev() {
    print_status "Deploying development environment..."
    
    # Stop existing containers
    docker-compose -f docker-compose.dev.yml down
    
    # Build and start services
    docker-compose -f docker-compose.dev.yml up --build -d
    
    print_success "Development environment deployed!"
    print_status "Services:"
    echo "  - Frontend: http://localhost:3000"
    echo "  - Backend API: http://localhost:5001"
    echo "  - Database: localhost:5432"
    echo "  - Redis: localhost:6379"
    
    print_status "Logs:"
    echo "  - View logs: docker-compose -f docker-compose.dev.yml logs -f"
    echo "  - Stop services: docker-compose -f docker-compose.dev.yml down"
}

# Function to deploy production environment
deploy_prod() {
    print_status "Deploying production environment..."
    
    # Stop existing containers
    docker-compose down
    
    # Build and start services
    docker-compose up --build -d
    
    print_success "Production environment deployed!"
    print_status "Services:"
    echo "  - Frontend: http://localhost:3000"
    echo "  - Backend API: http://localhost:5001"
    echo "  - Database: localhost:5432"
    echo "  - Redis: localhost:6379"
    
    print_status "Logs:"
    echo "  - View logs: docker-compose logs -f"
    echo "  - Stop services: docker-compose down"
}

# Function to deploy with Nginx
deploy_prod_nginx() {
    print_status "Deploying production environment with Nginx..."
    
    # Stop existing containers
    docker-compose down
    
    # Build and start services with Nginx
    docker-compose --profile production up --build -d
    
    print_success "Production environment with Nginx deployed!"
    print_status "Services:"
    echo "  - Frontend: http://localhost"
    echo "  - Backend API: http://localhost/api"
    echo "  - Database: localhost:5432"
    echo "  - Redis: localhost:6379"
    
    print_status "Logs:"
    echo "  - View logs: docker-compose logs -f"
    echo "  - Stop services: docker-compose down"
}

# Function to run database migrations
run_migrations() {
    print_status "Running database migrations..."
    
    # Wait for database to be ready
    sleep 10
    
    # Run migrations
    docker-compose exec backend npx prisma migrate deploy
    
    print_success "Database migrations completed!"
}

# Function to check service health
check_health() {
    print_status "Checking service health..."
    
    # Check backend
    if curl -s http://localhost:5001/api/health > /dev/null; then
        print_success "Backend API is healthy"
    else
        print_error "Backend API is not responding"
    fi
    
    # Check frontend
    if curl -s http://localhost:3000 > /dev/null; then
        print_success "Frontend is healthy"
    else
        print_error "Frontend is not responding"
    fi
    
    # Check database
    if docker-compose exec -T postgres pg_isready -U postgres > /dev/null 2>&1; then
        print_success "Database is healthy"
    else
        print_error "Database is not responding"
    fi
    
    # Check Redis
    if docker-compose exec -T redis redis-cli ping > /dev/null 2>&1; then
        print_success "Redis is healthy"
    else
        print_error "Redis is not responding"
    fi
}

# Function to show logs
show_logs() {
    print_status "Showing service logs..."
    docker-compose logs -f
}

# Function to clean up
cleanup() {
    print_status "Cleaning up Docker resources..."
    
    # Stop and remove containers
    docker-compose down
    
    # Remove volumes (optional)
    read -p "Do you want to remove volumes? This will delete all data. (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down -v
        print_warning "All data has been removed!"
    fi
    
    # Remove unused images
    docker image prune -f
    
    print_success "Cleanup completed!"
}

# Main menu
case "${1:-}" in
    "dev")
        deploy_dev
        ;;
    "prod")
        deploy_prod
        ;;
    "nginx")
        deploy_prod_nginx
        ;;
    "migrate")
        run_migrations
        ;;
    "health")
        check_health
        ;;
    "logs")
        show_logs
        ;;
    "cleanup")
        cleanup
        ;;
    "stop")
        print_status "Stopping all services..."
        docker-compose down
        docker-compose -f docker-compose.dev.yml down
        print_success "All services stopped!"
        ;;
    *)
        echo "Usage: $0 {dev|prod|nginx|migrate|health|logs|cleanup|stop}"
        echo ""
        echo "Commands:"
        echo "  dev     - Deploy development environment with hot reloading"
        echo "  prod    - Deploy production environment"
        echo "  nginx   - Deploy production environment with Nginx reverse proxy"
        echo "  migrate - Run database migrations"
        echo "  health  - Check service health"
        echo "  logs    - Show service logs"
        echo "  cleanup - Clean up Docker resources"
        echo "  stop    - Stop all services"
        echo ""
        echo "Examples:"
        echo "  $0 dev     # Start development environment"
        echo "  $0 prod    # Start production environment"
        echo "  $0 health  # Check if all services are running"
        ;;
esac 