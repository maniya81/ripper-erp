# Contributing to Ripper ERP

Thank you for your interest in contributing to Ripper ERP! This document provides guidelines and instructions for contributing.

## Code of Conduct

Be respectful, collaborative, and constructive. We're all here to build something great together.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/ripper-erp.git`
3. Create a feature branch: `git checkout -b feature/amazing-feature`
4. Make your changes
5. Commit your changes: `git commit -m 'Add amazing feature'`
6. Push to your branch: `git push origin feature/amazing-feature`
7. Open a Pull Request

## Development Setup

### Backend

```bash
cd backend
poetry install
poetry shell
cp .env.example .env
# Edit .env with your configuration
alembic upgrade head
uvicorn app.main:app --reload
```

### Frontend

```bash
cd frontend
npm install
cp .env.example .env
# Edit .env with your configuration
npm run dev
```

## Coding Standards

### Python (Backend)

- Follow PEP 8 style guide
- Use type hints where possible
- Write docstrings for functions and classes
- Format code with Black: `black app/`
- Lint with Ruff: `ruff check app/`
- Maximum line length: 100 characters

Example:

```python
def create_lead(lead_data: LeadCreate, db: Session) -> Lead:
    """
    Create a new lead in the database.

    Args:
        lead_data: The lead data to create
        db: Database session

    Returns:
        The created lead object
    """
    db_lead = Lead(**lead_data.model_dump())
    db.add(db_lead)
    db.commit()
    db.refresh(db_lead)
    return db_lead
```

### JavaScript/React (Frontend)

- Use functional components with hooks
- Follow ESLint rules
- Use meaningful variable names
- Keep components small and focused
- Format code: `npm run lint`

Example:

```jsx
const LeadCard = ({ lead, onEdit, onDelete }) => {
  const handleEdit = () => {
    onEdit(lead.id);
  };

  return (
    <div className="lead-card">
      <h3>
        {lead.first_name} {lead.last_name}
      </h3>
      <button onClick={handleEdit}>Edit</button>
    </div>
  );
};
```

## Testing

### Backend Tests

```bash
cd backend
pytest
pytest --cov=app
```

Write tests for:

- API endpoints
- Service functions
- Utility functions
- Database models

Example:

```python
def test_create_lead():
    response = client.post("/api/leads/", json={
        "first_name": "John",
        "email": "john@example.com"
    })
    assert response.status_code == 201
    assert response.json()["first_name"] == "John"
```

### Frontend Tests

```bash
cd frontend
npm run test  # When implemented
```

## Pull Request Process

1. Update the README.md with details of changes if needed
2. Update documentation if you're changing functionality
3. Add tests for new features
4. Ensure all tests pass
5. Update the changelog (if applicable)
6. Request review from maintainers

### PR Title Format

Use conventional commit format:

- `feat: Add Facebook Lead Ads integration`
- `fix: Correct email validation logic`
- `docs: Update API documentation`
- `style: Format code with Black`
- `refactor: Simplify lead creation logic`
- `test: Add tests for funnel endpoints`
- `chore: Update dependencies`

## Project Structure

```
ripper-erp/
├── backend/          # Python FastAPI backend
├── frontend/         # React frontend
├── docker/           # Docker configuration
├── docs/             # Documentation
└── scripts/          # Utility scripts
```

## Feature Requests

Open an issue with:

- Clear description of the feature
- Use cases
- Expected behavior
- Optional: Implementation suggestions

## Bug Reports

Open an issue with:

- Clear description of the bug
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Environment details

## Commit Messages

Write clear, descriptive commit messages:

Good:

```
feat: Add drag-and-drop support to funnel board

- Implemented drag-and-drop using HTML5 API
- Updated FunnelStage component
- Added moveLeadToStage function
```

Bad:

```
updated files
```

## Branch Naming

- `feature/feature-name` - New features
- `fix/bug-name` - Bug fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring
- `test/description` - Test additions

## Release Process

1. Update version in `package.json` and `pyproject.toml`
2. Update CHANGELOG.md
3. Create release tag: `git tag -a v1.0.0 -m "Release 1.0.0"`
4. Push tag: `git push origin v1.0.0`
5. Create GitHub release

## Questions?

Open an issue or reach out to the maintainers.

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to Ripper ERP! 🚀
