# Ripper ERP

A ripper of an ERP system - A modern, lightweight Customer Relationship Management (CRM) and lead management system built with FastAPI and React.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Python](https://img.shields.io/badge/python-3.11+-blue.svg)
![React](https://img.shields.io/badge/react-18+-blue.svg)

## 🚀 Features

- **Lead Management** - Capture and manage leads from multiple sources
- **Facebook Integration** - Automatic lead capture from Facebook Lead Ads
- **Sales Funnel** - Visual Kanban-style board for tracking lead progress
- **Contact Management** - Organize and manage customer contacts
- **Email Notifications** - Automated email alerts for new leads
- **WhatsApp Integration** - Send automated follow-up messages
- **Responsive Design** - Works seamlessly on desktop, tablet, and mobile
- **Modern UI** - Clean, intuitive interface built with Tailwind CSS
- **RESTful API** - Well-documented API with interactive documentation

## 📋 Table of Contents

- [Quick Start](#-quick-start)
- [Technology Stack](#-technology-stack)
- [Project Structure](#-project-structure)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [API Documentation](#-api-documentation)
- [Deployment](#-deployment)
- [Contributing](#-contributing)
- [License](#-license)

## ⚡ Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/ripper-erp.git
cd ripper-erp

# Run setup script (macOS/Linux)
chmod +x scripts/setup.sh
./scripts/setup.sh

# Or setup manually:

# Backend setup
cd backend
poetry install
cp .env.example .env
# Edit .env with your configuration
poetry shell
alembic upgrade head
uvicorn app.main:app --reload

# Frontend setup (new terminal)
cd frontend
npm install
cp .env.example .env
# Edit .env with your configuration
npm run dev
```

Visit:

- Frontend: http://localhost:5173
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

## 🛠️ Technology Stack

### Backend

- **FastAPI** - Modern Python web framework
- **SQLAlchemy** - SQL toolkit and ORM
- **PostgreSQL** - Relational database
- **Alembic** - Database migrations
- **Pydantic** - Data validation
- **Python 3.11+** - Programming language

### Frontend

- **React 18** - UI library
- **Vite** - Build tool and dev server
- **React Router** - Client-side routing
- **Tailwind CSS** - Utility-first CSS framework
- **Axios** - HTTP client
- **Heroicons** - Icon set

### Infrastructure

- **Docker** - Containerization
- **Azure Container Apps** - Backend hosting
- **Azure Static Web Apps** - Frontend hosting
- **GitHub Actions** - CI/CD
- **Supabase** - Database hosting (or Azure PostgreSQL)

## 📁 Project Structure

```
ripper-erp/
├── backend/              # Python FastAPI backend
│   ├── app/
│   │   ├── api/         # API routes
│   │   ├── models/      # Database models
│   │   ├── schemas/     # Pydantic schemas
│   │   ├── services/    # Business logic
│   │   └── utils/       # Utilities
│   ├── alembic/         # Database migrations
│   └── tests/           # Backend tests
├── frontend/            # React frontend
│   ├── src/
│   │   ├── components/  # React components
│   │   ├── pages/       # Page components
│   │   ├── hooks/       # Custom hooks
│   │   └── services/    # API services
│   └── public/          # Static assets
├── docker/              # Docker configuration
├── docs/                # Documentation
├── scripts/             # Utility scripts
└── .github/             # GitHub Actions workflows
```

## 💻 Installation

### Prerequisites

- Python 3.11 or higher
- Node.js 18 or higher
- PostgreSQL 14 or higher
- Poetry (Python package manager)
- Git

### Backend Installation

```bash
cd backend

# Install Poetry if not already installed
curl -sSL https://install.python-poetry.org | python3 -

# Install dependencies
poetry install

# Create and configure .env file
cp .env.example .env
# Edit .env with your database credentials and API keys

# Run database migrations
poetry shell
alembic upgrade head

# (Optional) Seed database with sample data
python ../scripts/seed_data.py
```

### Frontend Installation

```bash
cd frontend

# Install dependencies
npm install

# Create and configure .env file
cp .env.example .env
# Edit .env with your backend API URL
```

## ⚙️ Configuration

### Backend Environment Variables

Create `backend/.env`:

```env
DATABASE_URL=postgresql://user:password@localhost:5432/ripper_erp
SECRET_KEY=your-super-secret-key
FACEBOOK_APP_ID=your-facebook-app-id
FACEBOOK_APP_SECRET=your-facebook-app-secret
FACEBOOK_PAGE_ACCESS_TOKEN=your-page-access-token
WEBHOOK_VERIFY_TOKEN=your-webhook-verify-token
EMAIL_API_KEY=your-sendgrid-api-key
WHATSAPP_API_KEY=your-twilio-api-key
```

### Frontend Environment Variables

Create `frontend/.env`:

```env
VITE_API_URL=http://localhost:8000/api
VITE_APP_NAME=Ripper ERP
```

## 🎯 Usage

### Running Locally

```bash
# Terminal 1 - Backend
cd backend
poetry shell
uvicorn app.main:app --reload

# Terminal 2 - Frontend
cd frontend
npm run dev
```

### Using Docker

```bash
# Start all services
docker-compose -f docker/docker-compose.yml up -d

# View logs
docker-compose -f docker/docker-compose.yml logs -f

# Stop services
docker-compose -f docker/docker-compose.yml down
```

### Seeding Sample Data

```bash
cd backend
poetry shell
python ../scripts/seed_data.py
```

This creates:

- 7 funnel stages
- 50 sample leads
- 20 sample contacts
- 1 admin user (email: admin@ripperp.com, password: admin123)

## 📚 API Documentation

Interactive API documentation is available at:

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

See [docs/API.md](docs/API.md) for detailed API documentation.

### Example API Calls

```bash
# Get all leads
curl http://localhost:8000/api/leads/

# Create a new lead
curl -X POST http://localhost:8000/api/leads/ \
  -H "Content-Type: application/json" \
  -d '{"first_name":"John","last_name":"Doe","email":"john@example.com"}'

# Get funnel stages
curl http://localhost:8000/api/funnel/stages
```

## 🚀 Deployment

### Azure Deployment (Recommended)

See [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) for detailed deployment instructions.

**Estimated Monthly Cost:** $0-5 AUD using free tiers

- Azure Static Web Apps (Frontend): **FREE**
- Azure Container Apps (Backend): **FREE** (with limits)
- Supabase Database: **FREE**

### Quick Deploy

1. Fork this repository
2. Set up Azure resources (see deployment guide)
3. Configure GitHub secrets
4. Push to main branch - GitHub Actions will deploy automatically!

## 🧪 Testing

### Backend Tests

```bash
cd backend
poetry shell
pytest
pytest --cov=app  # With coverage
```

### Frontend Tests

```bash
cd frontend
npm run lint
npm run build  # Test build
```

## 📖 Documentation

- [API Documentation](docs/API.md)
- [Deployment Guide](docs/DEPLOYMENT.md)
- [Architecture Overview](docs/ARCHITECTURE.md)
- [Contributing Guidelines](docs/CONTRIBUTING.md)

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](docs/CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- FastAPI for the excellent Python web framework
- React team for the amazing UI library
- Tailwind CSS for the utility-first CSS framework
- All open-source contributors

## 📧 Contact

Project Link: [https://github.com/yourusername/ripper-erp](https://github.com/yourusername/ripper-erp)

---

Made with ❤️ in Australia 🇦🇺
