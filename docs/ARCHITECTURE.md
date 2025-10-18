# Architecture Overview

## System Architecture

Ripper ERP follows a modern microservices architecture with clear separation between frontend and backend.

```
┌─────────────────────────────────────────────────┐
│                   Client                        │
│              (React Frontend)                   │
└─────────────────┬───────────────────────────────┘
                  │
                  │ HTTP/HTTPS
                  │
┌─────────────────▼───────────────────────────────┐
│            Azure Static Web Apps                │
│         (CDN + Static File Hosting)             │
└─────────────────┬───────────────────────────────┘
                  │
                  │ API Calls
                  │
┌─────────────────▼───────────────────────────────┐
│         Azure Container Apps                    │
│          (FastAPI Backend)                      │
│                                                 │
│  ┌─────────────────────────────────────┐       │
│  │  API Layer (FastAPI Routes)         │       │
│  └───────────┬─────────────────────────┘       │
│              │                                  │
│  ┌───────────▼─────────────────────────┐       │
│  │  Business Logic (Services)          │       │
│  └───────────┬─────────────────────────┘       │
│              │                                  │
│  ┌───────────▼─────────────────────────┐       │
│  │  Data Access (Models + ORM)         │       │
│  └───────────┬─────────────────────────┘       │
└──────────────┼─────────────────────────────────┘
               │
               │ SQL
               │
┌──────────────▼─────────────────────────────────┐
│         PostgreSQL Database                     │
│        (Supabase or Azure)                     │
└─────────────────────────────────────────────────┘

External Services:
┌─────────────────────────────────────────────────┐
│  • Facebook Lead Ads (Webhooks)                 │
│  • SendGrid (Email)                             │
│  • Twilio (WhatsApp)                            │
└─────────────────────────────────────────────────┘
```

## Backend Architecture

### Layered Architecture

```
┌─────────────────────────────────────┐
│         API Routes Layer            │
│  (FastAPI routers, endpoints)       │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│         Service Layer               │
│  (Business logic, integrations)     │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│         Data Access Layer           │
│  (SQLAlchemy models, queries)       │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│         Database                    │
│  (PostgreSQL)                       │
└─────────────────────────────────────┘
```

### Directory Structure

```
backend/
├── app/
│   ├── api/              # API routes and endpoints
│   ├── models/           # SQLAlchemy database models
│   ├── schemas/          # Pydantic validation schemas
│   ├── services/         # Business logic and external integrations
│   ├── utils/            # Helper functions and utilities
│   ├── config.py         # Application configuration
│   ├── database.py       # Database connection management
│   └── main.py           # FastAPI application entry point
├── alembic/              # Database migrations
└── tests/                # Unit and integration tests
```

### Key Components

#### 1. API Routes (`app/api/routes/`)

- Handle HTTP requests and responses
- Input validation using Pydantic schemas
- Route organization by feature (leads, contacts, funnel, webhooks)

#### 2. Services (`app/services/`)

- Business logic implementation
- External service integrations (Facebook, email, WhatsApp)
- Data transformation and processing

#### 3. Models (`app/models/`)

- SQLAlchemy ORM models
- Database table definitions
- Relationships between entities

#### 4. Schemas (`app/schemas/`)

- Pydantic models for request/response validation
- Data serialization and deserialization
- Type safety

## Frontend Architecture

### Component Hierarchy

```
App
├── Header
├── Router
│   ├── HomePage
│   │   └── Dashboard
│   │       ├── Stats
│   │       └── RecentLeads
│   ├── LeadsPage
│   │   └── LeadList
│   │       ├── LeadForm
│   │       └── LeadDetails
│   ├── FunnelPage
│   │   └── FunnelBoard
│   │       └── FunnelStage[]
│   └── SettingsPage
└── Footer
```

### Directory Structure

```
frontend/
├── src/
│   ├── components/       # React components
│   │   ├── common/       # Reusable components
│   │   ├── leads/        # Lead-specific components
│   │   ├── funnel/       # Funnel-specific components
│   │   └── dashboard/    # Dashboard components
│   ├── pages/            # Page-level components
│   ├── hooks/            # Custom React hooks
│   ├── services/         # API client and services
│   ├── utils/            # Helper functions
│   └── App.jsx           # Root component
└── public/               # Static assets
```

### State Management

Currently using React hooks for state management:

- `useState` for local component state
- `useEffect` for side effects
- Custom hooks (`useLeads`, `useFunnel`) for shared logic

Future: Consider Redux or Zustand for complex state management.

## Data Flow

### Lead Creation Flow

```
User Action → LeadForm Component
              ↓
         API Call (POST /api/leads/)
              ↓
         FastAPI Route Handler
              ↓
         Pydantic Schema Validation
              ↓
         Service Layer Processing
              ↓
         Database Model Creation
              ↓
         SQLAlchemy Commit
              ↓
         Response to Frontend
              ↓
         Update UI State
```

### Facebook Webhook Flow

```
Facebook Lead Ad Submission
              ↓
         Webhook Event (POST /api/webhooks/facebook)
              ↓
         Verify Webhook Signature
              ↓
         Extract Lead ID
              ↓
         Fetch Full Lead Data from Facebook API
              ↓
         Create Lead in Database
              ↓
         Send Email Notification
              ↓
         Send WhatsApp Follow-up (if phone available)
```

## Database Schema

### Entity Relationship Diagram

```
┌──────────────┐         ┌──────────────┐
│    Users     │         │  FunnelStage │
└──────────────┘         └──────┬───────┘
                                │
                                │ 1:N
┌──────────────┐                │
│   Contacts   │         ┌──────▼───────┐
└──────────────┘         │    Leads     │
                         └──────────────┘
```

### Tables

#### Users

- id (PK)
- email
- username
- hashed_password
- first_name
- last_name
- is_active
- is_superuser
- created_at
- updated_at

#### Leads

- id (PK)
- first_name
- last_name
- email
- phone
- company
- source (enum: facebook, website, manual, referral)
- notes
- facebook_lead_id
- funnel_stage_id (FK → FunnelStage)
- created_at
- updated_at

#### FunnelStage

- id (PK)
- name
- description
- order
- color
- created_at
- updated_at

#### Contacts

- id (PK)
- first_name
- last_name
- email
- phone
- mobile
- company
- position
- address
- notes
- is_active
- created_at
- updated_at

## Security

### Authentication & Authorization

- JWT tokens for authentication (to be implemented)
- Role-based access control (RBAC)
- Secure password hashing with bcrypt

### API Security

- CORS configuration
- Input validation
- SQL injection protection (SQLAlchemy ORM)
- XSS protection
- Rate limiting (to be implemented)

### Data Protection

- Environment variables for sensitive data
- Secrets management in Azure Key Vault
- HTTPS/TLS encryption
- Database connection encryption

## Performance Optimization

### Backend

- Database query optimization
- Connection pooling
- Caching (to be implemented)
- Async/await for I/O operations
- Pagination for large datasets

### Frontend

- Code splitting
- Lazy loading
- Image optimization
- CDN for static assets
- Build optimization with Vite

## Scalability

### Horizontal Scaling

- Stateless API design
- Load balancing with Azure Container Apps
- Database read replicas (future)
- CDN for global distribution

### Vertical Scaling

- Container resource allocation
- Database tier upgrades
- Cache layer addition

## Monitoring & Observability

### Logging

- Structured logging
- Log aggregation in Azure Monitor
- Error tracking

### Metrics

- API response times
- Database query performance
- Error rates
- User activity

### Alerts

- Performance degradation
- Error spikes
- Resource utilization

## Future Enhancements

1. **Real-time Features**

   - WebSocket support
   - Live updates for funnel board
   - Real-time notifications

2. **Advanced Features**

   - Email template builder
   - Automated workflows
   - Advanced analytics
   - AI-powered lead scoring

3. **Infrastructure**
   - Kubernetes deployment
   - Multi-region deployment
   - Advanced caching (Redis)
   - Message queue (RabbitMQ/Azure Service Bus)
