# Ripper ERP - Backend

This is the backend API for Ripper ERP, built with FastAPI and PostgreSQL.

## 🚀 Quick Start

### Prerequisites

- Python 3.11+
- Poetry (Python package manager)
- PostgreSQL database

### Installation

```bash
# Install Poetry (if not already installed)
curl -sSL https://install.python-poetry.org | python3 -

# Install dependencies
poetry install

# Activate virtual environment
poetry shell

# Copy environment file
cp .env.example .env

# Edit .env with your configuration
nano .env
```

### Database Setup

```bash
# Run database migrations
alembic upgrade head

# Or create initial migration (if needed)
alembic revision --autogenerate -m "Initial migration"
alembic upgrade head
```

### Running the Application

```bash
# Development mode with auto-reload
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Production mode
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

The API will be available at:

- API: http://localhost:8000
- Interactive API docs: http://localhost:8000/docs
- Alternative API docs: http://localhost:8000/redoc

## 📁 Project Structure

```
backend/
├── app/
│   ├── api/              # API routes
│   ├── models/           # SQLAlchemy models
│   ├── schemas/          # Pydantic schemas
│   ├── services/         # Business logic
│   ├── utils/            # Utilities
│   ├── config.py         # Configuration
│   ├── database.py       # Database connection
│   └── main.py           # FastAPI app
├── alembic/              # Database migrations
├── tests/                # Unit tests
├── pyproject.toml        # Poetry dependencies
└── .env.example          # Environment variables template
```

## 🧪 Running Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=app --cov-report=html

# Run specific test file
pytest tests/test_leads.py
```

## 📚 API Endpoints

### Leads

- `GET /api/leads/` - List all leads
- `GET /api/leads/{id}` - Get specific lead
- `POST /api/leads/` - Create new lead
- `PUT /api/leads/{id}` - Update lead
- `DELETE /api/leads/{id}` - Delete lead

### Webhooks

- `GET /api/webhooks/facebook` - Facebook webhook verification
- `POST /api/webhooks/facebook` - Receive Facebook lead events

### Contacts

- `GET /api/contacts/` - List all contacts
- `GET /api/contacts/{id}` - Get specific contact
- `POST /api/contacts/` - Create new contact
- `PUT /api/contacts/{id}` - Update contact
- `DELETE /api/contacts/{id}` - Delete contact

### Funnel

- `GET /api/funnel/stages` - Get all funnel stages
- `POST /api/funnel/stages` - Create funnel stage
- `PUT /api/funnel/stages/{id}` - Update funnel stage
- `POST /api/funnel/move-lead/{lead_id}/{stage_id}` - Move lead to stage

## 🔧 Development

### Code Formatting

```bash
# Format code with Black
black app/

# Lint with Ruff
ruff check app/

# Type checking with MyPy
mypy app/
```

### Database Migrations

```bash
# Create a new migration
alembic revision --autogenerate -m "Description of changes"

# Apply migrations
alembic upgrade head

# Rollback migration
alembic downgrade -1

# View migration history
alembic history
```

## 🔐 Environment Variables

See `.env.example` for all required environment variables.

Key variables:

- `DATABASE_URL` - PostgreSQL connection string
- `SECRET_KEY` - JWT secret key for authentication
- `FACEBOOK_*` - Facebook API credentials
- `EMAIL_API_KEY` - Email service API key
- `WHATSAPP_API_KEY` - WhatsApp service API key

## 📦 Dependencies

Main dependencies:

- FastAPI - Modern web framework
- SQLAlchemy - ORM for database
- Pydantic - Data validation
- Alembic - Database migrations
- Uvicorn - ASGI server
- python-jose - JWT tokens
- passlib - Password hashing
- httpx - HTTP client

## 🚀 Deployment

See the main repository README for deployment instructions to Azure.

## 📝 License

See LICENSE file in the root directory.
