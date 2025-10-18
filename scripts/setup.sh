#!/bin/bash

# Ripper ERP Setup Script
# This script sets up the development environment for Ripper ERP

set -e  # Exit on error

echo "🚀 Setting up Ripper ERP development environment..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check prerequisites
echo ""
echo "📋 Checking prerequisites..."

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    print_success "Python found: $PYTHON_VERSION"
else
    print_error "Python 3 is not installed"
    exit 1
fi

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_success "Node.js found: $NODE_VERSION"
else
    print_error "Node.js is not installed"
    exit 1
fi

# Check Poetry
if command -v poetry &> /dev/null; then
    POETRY_VERSION=$(poetry --version)
    print_success "Poetry found: $POETRY_VERSION"
else
    print_warning "Poetry not found. Installing..."
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
    print_success "Poetry installed"
fi

# Check PostgreSQL
if command -v psql &> /dev/null; then
    POSTGRES_VERSION=$(psql --version)
    print_success "PostgreSQL found: $POSTGRES_VERSION"
else
    print_warning "PostgreSQL not found. Please install it manually."
fi

# Setup Backend
echo ""
echo "🐍 Setting up backend..."
cd backend

# Create .env if it doesn't exist
if [ ! -f .env ]; then
    cp .env.example .env
    print_success "Created .env file from .env.example"
    print_warning "Please edit backend/.env with your configuration"
else
    print_warning ".env file already exists"
fi

# Install Python dependencies
echo "Installing Python dependencies..."
poetry install
print_success "Python dependencies installed"

# Setup Frontend
echo ""
echo "⚛️  Setting up frontend..."
cd ../frontend

# Create .env if it doesn't exist
if [ ! -f .env ]; then
    cp .env.example .env
    print_success "Created .env file from .env.example"
    print_warning "Please edit frontend/.env with your configuration"
else
    print_warning ".env file already exists"
fi

# Install Node dependencies
echo "Installing Node.js dependencies..."
npm install
print_success "Node.js dependencies installed"

cd ..

# Summary
echo ""
echo "================================================================"
echo "✅ Setup complete!"
echo "================================================================"
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Configure your database:"
echo "   - Edit backend/.env with your database credentials"
echo ""
echo "2. Run database migrations:"
echo "   cd backend"
echo "   poetry shell"
echo "   alembic upgrade head"
echo ""
echo "3. Start the backend:"
echo "   uvicorn app.main:app --reload"
echo ""
echo "4. In a new terminal, start the frontend:"
echo "   cd frontend"
echo "   npm run dev"
echo ""
echo "5. Access the application:"
echo "   Frontend: http://localhost:5173"
echo "   Backend API: http://localhost:8000"
echo "   API Docs: http://localhost:8000/docs"
echo ""
echo "================================================================"
echo ""
echo "For more information, see README.md"
echo ""
