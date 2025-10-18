# Azure Web App Deployment Guide - Frontend Only

This guide will walk you through deploying the Ripper ERP frontend to Azure Web App using GitHub Actions.

## 📋 Prerequisites

- Azure account with active subscription
- Azure CLI installed (`brew install azure-cli` on macOS)
- GitHub repository with your code
- Node.js 20+ installed locally

## 🚀 Step-by-Step Deployment

### Step 1: Login to Azure

```bash
# Login to Azure
az login

# Verify you're logged in and see your subscriptions
az account list --output table

# Set the subscription you want to use (if you have multiple)
az account set --subscription "Your Subscription Name or ID"
```

### Step 2: Create Resource Group (if not exists)

```bash
# Create resource group in your preferred region
az group create \
  --name ripper-erp-frontend-rg \
  --location "Canada Central"

# Or use an existing one
az group list --output table
```

### Step 3: Create Azure Web App

Based on your screenshot, you're creating a Web App. Here's how to do it via CLI:

```bash
# Create App Service Plan (this determines pricing)
# For production, use P1V3 or higher
# For development/testing, use B1 (Basic)
az appservice plan create \
  --name ripper-frontend-plan \
  --resource-group ripper-erp-frontend-rg \
  --sku B1 \
  --is-linux

# Create the Web App with Node.js runtime
az webapp create \
  --resource-group ripper-erp-frontend-rg \
  --plan ripper-frontend-plan \
  --name ripper \
  --runtime "NODE:20-lts"
```

**Important**: The app name (e.g., `ripper`) must be globally unique as it becomes `ripper.azurewebsites.net`

### Step 4: Configure Web App for SPA (Single Page Application)

Since you're deploying a React/Vite app, you need to configure it to serve the SPA correctly:

```bash
# Enable local cache (optional, improves performance)
az webapp config appsettings set \
  --resource-group ripper-erp-frontend-rg \
  --name ripper \
  --settings WEBSITE_LOCAL_CACHE_OPTION=Always

# Configure startup command for serving static files
az webapp config set \
  --resource-group ripper-erp-frontend-rg \
  --name ripper \
  --startup-file "pm2 serve /home/site/wwwroot --no-daemon --spa"
```

### Step 5: Add web.config for URL Rewriting

Create a `web.config` file in your frontend directory to handle client-side routing:

```bash
cd /Users/matt/Desktop/ripper/ripper-erp/frontend
```

Create `web.config`:

```xml
<?xml version="1.0"?>
<configuration>
  <system.webServer>
    <rewrite>
      <rules>
        <rule name="React Routes" stopProcessing="true">
          <match url=".*" />
          <conditions logicalGrouping="MatchAll">
            <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
            <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
            <add input="{REQUEST_URI}" pattern="^/(api)" negate="true" />
          </conditions>
          <action type="Rewrite" url="/" />
        </rule>
      </rules>
    </rewrite>
    <staticContent>
      <mimeMap fileExtension=".json" mimeType="application/json" />
    </staticContent>
  </system.webServer>
</configuration>
```

### Step 6: Get Publish Profile

```bash
# Download the publish profile
az webapp deployment list-publishing-profiles \
  --resource-group ripper-erp-frontend-rg \
  --name ripper \
  --xml > ripper-publish-profile.xml

# Display the content (you'll need this for GitHub secrets)
cat ripper-publish-profile.xml
```

### Step 7: Configure GitHub Secrets

1. Go to your GitHub repository: `https://github.com/maniya81/ripper-erp`
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** and add the following:

#### Required Secrets:

**Secret 1: AZURE_WEBAPP_NAME**

- Name: `AZURE_WEBAPP_NAME`
- Value: `ripper` (or whatever you named your web app)

**Secret 2: AZURE_WEBAPP_PUBLISH_PROFILE**

- Name: `AZURE_WEBAPP_PUBLISH_PROFILE`
- Value: Copy the entire contents of `ripper-publish-profile.xml`

**Secret 3: VITE_API_URL** (optional, for backend API)

- Name: `VITE_API_URL`
- Value: `https://your-backend-api.azurewebsites.net/api` (or your backend URL)

### Step 8: Verify GitHub Actions Workflow

The workflow has been updated at `.github/workflows/frontend-deploy.yml`. It will:

1. ✅ Trigger on push to `main` branch when frontend files change
2. ✅ Set up Node.js 20
3. ✅ Install dependencies with `npm ci`
4. ✅ Build the application with `npm run build`
5. ✅ Create a deployment package
6. ✅ Deploy to Azure Web App

### Step 9: Deploy

Now you can deploy in two ways:

#### Option A: Automatic Deployment (Recommended)

```bash
# Commit and push your changes
cd /Users/matt/Desktop/ripper/ripper-erp
git add .
git commit -m "Configure Azure Web App deployment"
git push origin main
```

GitHub Actions will automatically build and deploy your frontend!

#### Option B: Manual Deployment (Testing)

```bash
# Navigate to frontend directory
cd /Users/matt/Desktop/ripper/ripper-erp/frontend

# Install dependencies
npm install

# Build the application
npm run build

# Deploy using Azure CLI
az webapp deployment source config-zip \
  --resource-group ripper-erp-frontend-rg \
  --name ripper \
  --src dist.zip
```

First, zip your dist folder:

```bash
cd dist
zip -r ../dist.zip .
cd ..
```

### Step 10: Verify Deployment

1. **Check GitHub Actions**:

   - Go to your repository → **Actions** tab
   - Watch the workflow run

2. **Access your app**:

   ```
   https://ripper.azurewebsites.net
   ```

3. **Check logs** (if issues):

   ```bash
   # Stream live logs
   az webapp log tail \
     --resource-group ripper-erp-frontend-rg \
     --name ripper

   # Download logs
   az webapp log download \
     --resource-group ripper-erp-frontend-rg \
     --name ripper \
     --log-file logs.zip
   ```

## 🔧 Configuration & Environment Variables

### Add Environment Variables to Web App

```bash
# Add application settings (environment variables)
az webapp config appsettings set \
  --resource-group ripper-erp-frontend-rg \
  --name ripper \
  --settings \
    VITE_API_URL="https://your-backend.azurewebsites.net/api" \
    NODE_ENV="production"
```

**Note**: Vite environment variables must be prefixed with `VITE_` to be accessible in the browser.

## 📊 Monitoring & Troubleshooting

### Enable Application Insights (Optional)

```bash
# Create Application Insights
az monitor app-insights component create \
  --app ripper-insights \
  --location "Canada Central" \
  --resource-group ripper-erp-frontend-rg \
  --application-type web

# Link to Web App
INSTRUMENTATION_KEY=$(az monitor app-insights component show \
  --app ripper-insights \
  --resource-group ripper-erp-frontend-rg \
  --query instrumentationKey -o tsv)

az webapp config appsettings set \
  --resource-group ripper-erp-frontend-rg \
  --name ripper \
  --settings APPINSIGHTS_INSTRUMENTATIONKEY="$INSTRUMENTATION_KEY"
```

### Common Issues & Solutions

#### Issue 1: 404 on Page Refresh

**Solution**: Make sure `web.config` is in your `dist` folder or configure URL rewrite in Azure.

```bash
# Add to your vite.config.js/ts
export default defineConfig({
  // ... other config
  build: {
    rollupOptions: {
      output: {
        manualChunks: undefined,
      }
    }
  },
  // Copy web.config to dist during build
})
```

#### Issue 2: Environment Variables Not Working

**Solution**: Rebuild the app with the correct environment variables set during build time.

#### Issue 3: App Not Starting

**Solution**: Check startup command and logs:

```bash
az webapp config show \
  --resource-group ripper-erp-frontend-rg \
  --name ripper \
  --query linuxFxVersion

az webapp log tail \
  --resource-group ripper-erp-frontend-rg \
  --name ripper
```

## 💰 Cost Optimization

### Pricing Tiers

Based on your screenshot, you selected **Premium V3 P1MV3**:

- ~$195 CAD/month
- 2 vCPU, 16 GB memory
- Good for production

### Alternative Options:

1. **Basic B1** (~$15 CAD/month)

   - Good for development/testing
   - 1 core, 1.75 GB RAM

   ```bash
   az appservice plan update \
     --name ripper-frontend-plan \
     --resource-group ripper-erp-frontend-rg \
     --sku B1
   ```

2. **Standard S1** (~$70 CAD/month)

   - Good for small production apps
   - Auto-scaling available

3. **Free F1** ($0/month)
   - 60 minutes/day compute time
   - Good for demos only
   ```bash
   az appservice plan update \
     --name ripper-frontend-plan \
     --resource-group ripper-erp-frontend-rg \
     --sku F1
   ```

### Scale Down When Not in Use

```bash
# Scale down to save costs
az appservice plan update \
  --name ripper-frontend-plan \
  --resource-group ripper-erp-frontend-rg \
  --sku B1

# Scale up for production
az appservice plan update \
  --name ripper-frontend-plan \
  --resource-group ripper-erp-frontend-rg \
  --sku P1V3
```

## 🔒 Security

### Enable HTTPS Only

```bash
az webapp update \
  --resource-group ripper-erp-frontend-rg \
  --name ripper \
  --https-only true
```

### Configure CORS (if needed)

```bash
az webapp cors add \
  --resource-group ripper-erp-frontend-rg \
  --name ripper \
  --allowed-origins "https://yourdomain.com"
```

## 🌐 Custom Domain (Optional)

```bash
# Add custom domain
az webapp config hostname add \
  --resource-group ripper-erp-frontend-rg \
  --webapp-name ripper \
  --hostname www.yourdomain.com

# Enable SSL
az webapp config ssl bind \
  --resource-group ripper-erp-frontend-rg \
  --name ripper \
  --certificate-thumbprint <thumbprint> \
  --ssl-type SNI
```

## 📝 Quick Reference Commands

```bash
# View app URL
az webapp show \
  --resource-group ripper-erp-frontend-rg \
  --name ripper \
  --query defaultHostName -o tsv

# Restart app
az webapp restart \
  --resource-group ripper-erp-frontend-rg \
  --name ripper

# View app settings
az webapp config appsettings list \
  --resource-group ripper-erp-frontend-rg \
  --name ripper \
  --output table

# Delete everything (cleanup)
az group delete \
  --name ripper-erp-frontend-rg \
  --yes
```

## ✅ Deployment Checklist

- [ ] Azure CLI installed and logged in
- [ ] Resource group created
- [ ] App Service Plan created
- [ ] Web App created with Node.js runtime
- [ ] Publish profile downloaded
- [ ] GitHub secrets configured (AZURE_WEBAPP_NAME, AZURE_WEBAPP_PUBLISH_PROFILE)
- [ ] Environment variables set (VITE_API_URL if needed)
- [ ] web.config created for SPA routing
- [ ] Code committed and pushed to GitHub
- [ ] GitHub Actions workflow successful
- [ ] Application accessible at azurewebsites.net URL
- [ ] HTTPS enforced
- [ ] Monitoring configured (optional)

## 🎯 Next Steps

1. Set up backend deployment (if needed)
2. Configure custom domain
3. Set up CI/CD for staging environment
4. Configure Application Insights for monitoring
5. Set up automated backups
6. Configure auto-scaling rules

---

**Need Help?**

- Azure Web App Documentation: https://docs.microsoft.com/azure/app-service/
- GitHub Actions Documentation: https://docs.github.com/actions
