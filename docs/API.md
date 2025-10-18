# API Documentation

## Base URL

```
http://localhost:8000/api
```

Production: `https://your-backend.azurecontainerapps.io/api`

## Authentication

Currently, the API doesn't require authentication for most endpoints. JWT authentication will be implemented in future versions.

## Endpoints

### Health Check

#### GET /health

Check if the API is running.

**Response:**

```json
{
  "status": "healthy"
}
```

---

### Leads

#### GET /api/leads/

Get all leads.

**Query Parameters:**

- `skip` (optional): Number of records to skip (default: 0)
- `limit` (optional): Maximum number of records to return (default: 100)

**Response:**

```json
[
  {
    "id": 1,
    "first_name": "John",
    "last_name": "Doe",
    "email": "john.doe@example.com",
    "phone": "+61400000000",
    "company": "Acme Corp",
    "source": "facebook",
    "notes": "Interested in our services",
    "facebook_lead_id": "123456789",
    "funnel_stage_id": 1,
    "created_at": "2024-01-01T00:00:00",
    "updated_at": "2024-01-01T00:00:00"
  }
]
```

#### GET /api/leads/{id}

Get a specific lead by ID.

**Response:**

```json
{
  "id": 1,
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@example.com",
  "phone": "+61400000000",
  "company": "Acme Corp",
  "source": "facebook",
  "notes": "Interested in our services",
  "created_at": "2024-01-01T00:00:00",
  "updated_at": "2024-01-01T00:00:00"
}
```

#### POST /api/leads/

Create a new lead.

**Request Body:**

```json
{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john.doe@example.com",
  "phone": "+61400000000",
  "company": "Acme Corp",
  "source": "manual",
  "notes": "Contacted via website form"
}
```

**Response:** 201 Created

#### PUT /api/leads/{id}

Update an existing lead.

**Request Body:**

```json
{
  "first_name": "John",
  "email": "newemail@example.com",
  "funnel_stage_id": 2
}
```

**Response:** 200 OK

#### DELETE /api/leads/{id}

Delete a lead.

**Response:** 204 No Content

---

### Contacts

#### GET /api/contacts/

Get all contacts.

#### POST /api/contacts/

Create a new contact.

#### PUT /api/contacts/{id}

Update a contact.

#### DELETE /api/contacts/{id}

Delete a contact.

---

### Funnel

#### GET /api/funnel/stages

Get all funnel stages.

**Response:**

```json
[
  {
    "id": 1,
    "name": "New Lead",
    "description": "Newly captured leads",
    "order": 1,
    "color": "#3B82F6",
    "created_at": "2024-01-01T00:00:00",
    "updated_at": "2024-01-01T00:00:00"
  }
]
```

#### POST /api/funnel/stages

Create a new funnel stage.

**Request Body:**

```json
{
  "name": "Qualified",
  "description": "Qualified leads ready for proposal",
  "order": 2,
  "color": "#10B981"
}
```

#### PUT /api/funnel/stages/{id}

Update a funnel stage.

#### POST /api/funnel/move-lead/{lead_id}/{stage_id}

Move a lead to a different funnel stage.

**Response:**

```json
{
  "status": "success",
  "lead_id": 1,
  "new_stage": "Qualified"
}
```

---

### Webhooks

#### GET /api/webhooks/facebook

Facebook webhook verification endpoint.

**Query Parameters:**

- `hub.mode`: Should be "subscribe"
- `hub.verify_token`: Your webhook verify token
- `hub.challenge`: Challenge string from Facebook

**Response:** Returns the challenge value

#### POST /api/webhooks/facebook

Receive Facebook Lead Ads webhook events.

**Request Body:**

```json
{
  "object": "page",
  "entry": [
    {
      "changes": [
        {
          "field": "leadgen",
          "value": {
            "leadgen_id": "123456789",
            "ad_id": "987654321"
          }
        }
      ]
    }
  ]
}
```

**Response:**

```json
{
  "status": "ok"
}
```

---

## Error Responses

### 400 Bad Request

```json
{
  "detail": "Invalid request data"
}
```

### 404 Not Found

```json
{
  "detail": "Lead not found"
}
```

### 422 Validation Error

```json
{
  "detail": [
    {
      "loc": ["body", "email"],
      "msg": "value is not a valid email address",
      "type": "value_error.email"
    }
  ]
}
```

### 500 Internal Server Error

```json
{
  "detail": "Internal server error"
}
```

---

## Rate Limiting

Currently no rate limiting is implemented. This will be added in future versions.

## Interactive Documentation

Visit `/docs` for Swagger UI interactive documentation.
Visit `/redoc` for ReDoc documentation.
