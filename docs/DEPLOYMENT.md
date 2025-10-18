# Deployment Guide

## Azure Deployment (Recommended)

### Prerequisites

- Azure account
- Azure CLI installed
- GitHub account
- Domain name (optional)

### 1. Setup Azure Resources

```bash
# Login to Azure
az login

# Create resource group
az group create \
  --name ripper-erp-rg \
  --location australiaeast

# Create Container Registry
az acr create \
  --resource-group ripper-erp-rg \
  --name ripperacr \
  --sku Basic

# Create Container Apps environment
az containerapp env create \
  --name ripper-env \
  --resource-group ripper-erp-rg \
  --location australiaeast
```

### 2. Database Setup

**Option A: Supabase (FREE)**

1. Sign up at https://supabase.com
2. Create a new project
3. Copy the PostgreSQL connection string
4. Use in your backend configuration

**Option B: Azure PostgreSQL Flexible Server**

```bash
az postgres flexible-server create \
  --resource-group ripper-erp-rg \
  --name ripper-db \
  --location australiaeast \
  --admin-user ripperadmin \
  --admin-password <your-password> \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --storage-size 32
```

### 3. Deploy Backend (Container Apps)

```bash
# Build and push image
az acr build \
  --registry ripperacr \
  --image ripper-backend:latest \
  --file docker/Dockerfile.backend \
  .

# Create Container App
az containerapp create \
  --name ripper-backend \
  --resource-group ripper-erp-rg \
  --environment ripper-env \
  --image ripperacr.azurecr.io/ripper-backend:latest \
  --target-port 8000 \
  --ingress external \
  --registry-server ripperacr.azurecr.io \
  --min-replicas 0 \
  --max-replicas 1

# Set secrets
az containerapp secret set \
  --name ripper-backend \
  --resource-group ripper-erp-rg \
  --secrets \
    database-url=<your-db-url> \
    secret-key=<your-secret-key> \
    facebook-app-id=<your-fb-app-id>

# Set environment variables
az containerapp update \
  --name ripper-backend \
  --resource-group ripper-erp-rg \
  --set-env-vars \
    DATABASE_URL=secretref:database-url \
    SECRET_KEY=secretref:secret-key
```

### 4. Deploy Frontend (Static Web Apps)

```bash
# Install SWA CLI
npm install -g @azure/static-web-apps-cli

# Create Static Web App
az staticwebapp create \
  --name ripper-frontend \
  --resource-group ripper-erp-rg \
  --location eastasia

# Get deployment token
az staticwebapp secrets list \
  --name ripper-frontend \
  --resource-group ripper-erp-rg
```

### 5. Configure GitHub Actions

1. Go to your GitHub repository settings
2. Add the following secrets:
   - `AZURE_CREDENTIALS`: Azure service principal credentials
   - `AZURE_REGISTRY_NAME`: Your ACR name (ripperacr)
   - `AZURE_STATIC_WEB_APPS_API_TOKEN`: From step 4
   - `VITE_API_URL`: Your backend URL

Create service principal:

```bash
az ad sp create-for-rbac \
  --name ripper-erp-deploy \
  --role contributor \
  --scopes /subscriptions/<subscription-id>/resourceGroups/ripper-erp-rg \
  --sdk-auth
```

### 6. Push to GitHub

```bash
git add .
git commit -m "Initial deployment"
git push origin main
```

GitHub Actions will automatically deploy your application!

---

## Docker Deployment

### Local Development

```bash
# Start all services
docker-compose -f docker/docker-compose.yml up -d

# View logs
docker-compose -f docker/docker-compose.yml logs -f

# Stop services
docker-compose -f docker/docker-compose.yml down
```

### Production Docker

```bash
# Build images
docker build -f docker/Dockerfile.backend -t ripper-backend .
docker build -f docker/Dockerfile.frontend -t ripper-frontend .

# Run with docker-compose
docker-compose -f docker/docker-compose.yml up -d
```

---

## Alternative Hosting Options

### Vercel (Frontend)

```bash
cd frontend
npm install -g vercel
vercel
```

### Railway.app (Full Stack)

1. Connect your GitHub repo
2. Railway will auto-detect and deploy
3. Add environment variables in dashboard

### Render.com (Full Stack)

1. Create new Web Service
2. Connect GitHub repo
3. Configure build and start commands
4. Add environment variables

---

## Custom Domain Setup

### Azure Static Web Apps

```bash
az staticwebapp hostname set \
  --name ripper-frontend \
  --resource-group ripper-erp-rg \
  --hostname www.yourdomai.com
```

Add DNS records:

- CNAME: `www` → `<static-web-app-url>`

### SSL Certificates

Azure Static Web Apps provides automatic SSL certificates for custom domains.

---

## Monitoring & Logs

### Azure Container Apps Logs

```bash
az containerapp logs show \
  --name ripper-backend \
  --resource-group ripper-erp-rg \
  --follow
```

### Application Insights

```bash
az monitor app-insights component create \
  --app ripper-insights \
  --location australiaeast \
  --resource-group ripper-erp-rg
```

---

## Scaling

### Container Apps Auto-scaling

```bash
az containerapp update \
  --name ripper-backend \
  --resource-group ripper-erp-rg \
  --min-replicas 1 \
  --max-replicas 5
```

### Database Scaling

Upgrade your database tier as needed through Azure Portal or CLI.

---

## Backup & Recovery

### Database Backups

Azure PostgreSQL provides automatic backups.

```bash
az postgres flexible-server backup list \
  --resource-group ripper-erp-rg \
  --name ripper-db
```

### Container Registry Backups

Images in ACR are automatically geo-replicated (if enabled).

---

## Cost Optimization

1. Use Azure Container Apps consumption plan (pay per use)
2. Use Supabase free tier for database
3. Enable auto-scaling to scale to zero
4. Use Azure Static Web Apps free tier
5. Monitor usage with Azure Cost Management

**Estimated Monthly Cost:**

- Static Web Apps: $0
- Container Apps (light usage): $0-5
- Supabase Database: $0
- **Total: $0-5 AUD/month**
