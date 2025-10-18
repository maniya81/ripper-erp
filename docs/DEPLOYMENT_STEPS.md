# Azure Web App Deployment - Step by Step Guide

## ✅ Web App Created Successfully!

Your Azure Web App has been created with these settings:

- **Name**: `ripper`
- **URL**: `https://ripper.azurewebsites.net`
- **OS**: Linux
- **Runtime**: Node 22 LTS
- **Region**: Australia East
- **Plan**: Free F1

---

## 🚀 Deployment Steps

### Step 1: Download Publish Profile ✅ (Current Step)

1. Go to Azure Portal: https://portal.azure.com
2. Navigate to **App Services** > **ripper**
3. Click **"Get publish profile"** or **"Download publish profile"** at the top
4. Save the `.PublishSettings` file to your computer

---

### Step 2: Add Publish Profile to GitHub Secrets

#### Method A: Via GitHub Web Interface (Recommended)

1. Open your browser and go to:

   ```
   https://github.com/maniya81/ripper-erp/settings/secrets/actions
   ```

2. Click **"New repository secret"**

3. Fill in the form:

   - **Name**: `AZURE_WEBAPP_PUBLISH_PROFILE`
   - **Secret**: Open the downloaded `.PublishSettings` file in a text editor and copy **ALL** the content

4. Click **"Add secret"**

#### Method B: Via Command Line

```bash
# Navigate to your project
cd /Users/matt/Desktop/ripper/ripper-erp

# Install GitHub CLI if not already installed
brew install gh

# Login to GitHub
gh auth login

# Add the secret (replace path with actual path to downloaded file)
gh secret set AZURE_WEBAPP_PUBLISH_PROFILE < ~/Downloads/ripper.PublishSettings
```

---

### Step 3: Add API URL Secret

Your frontend needs to know where the backend API is. Add this secret:

1. Go to: https://github.com/maniya81/ripper-erp/settings/secrets/actions
2. Click **"New repository secret"**
3. Fill in:
   - **Name**: `VITE_API_URL`
   - **Secret**: `http://localhost:8000/api` (or your actual backend URL)
4. Click **"Add secret"**

---

### Step 4: Configure Azure Web App Settings

1. Go to Azure Portal > Your Web App (`ripper`)
2. In the left menu, click **Configuration** > **Application settings**
3. Click **"+ New application setting"** and add these:

| Name                             | Value    |
| -------------------------------- | -------- |
| `WEBSITE_NODE_DEFAULT_VERSION`   | `22-lts` |
| `SCM_DO_BUILD_DURING_DEPLOYMENT` | `false`  |
| `WEBSITE_RUN_FROM_PACKAGE`       | `1`      |

4. Click **Save** at the top

---

### Step 5: Set Startup Command

1. Still in **Configuration** > **General settings**
2. Find **Startup Command**
3. Enter:
   ```bash
   npm run start:prod
   ```
4. Click **Save**

---

### Step 6: Push Code to GitHub

The GitHub Actions workflow is now ready. Let's deploy:

```bash
cd /Users/matt/Desktop/ripper/ripper-erp

# Stage all changes
git add .

# Commit
git commit -m "feat: add Azure Web App deployment configuration"

# Push to main branch (this triggers deployment)
git push origin main
```

---

### Step 7: Monitor Deployment

1. Go to GitHub: https://github.com/maniya81/ripper-erp/actions
2. You'll see a new workflow run "Deploy Frontend to Azure Web App"
3. Click on it to watch the progress
4. Wait for both jobs (build + deploy) to complete (green checkmarks)

---

### Step 8: Verify Deployment

Once deployment is complete:

1. Visit your app: https://ripper.azurewebsites.net
2. Check if the app loads correctly
3. If you see errors, check the logs:
   ```bash
   az webapp log tail --name ripper --resource-group ripper-erp-frontend-rg
   ```

---

## 🔧 Troubleshooting

### If Deployment Fails

#### Check Build Logs

1. Go to GitHub Actions
2. Click on the failed workflow
3. Check the "build" and "deploy" job logs

#### Check Azure Logs

```bash
# Stream live logs
az webapp log tail --name ripper --resource-group ripper-erp-frontend-rg

# Download logs
az webapp log download --name ripper --resource-group ripper-erp-frontend-rg
```

### If App Shows 404 or Blank Page

1. Check if build created `dist` folder:

   - Look at GitHub Actions build logs
   - Ensure `npm run build` completed successfully

2. Verify startup command:

   ```bash
   az webapp config show --name ripper --resource-group ripper-erp-frontend-rg --query linuxFxVersion
   ```

3. Check application logs for errors

---

## 📝 Environment Variables

After deployment, you may need to add environment variables:

### In Azure Portal:

1. Go to **Configuration** > **Application settings**
2. Add any `VITE_*` variables your app needs:
   - `VITE_API_URL`
   - `VITE_APP_NAME`
   - etc.

### In GitHub Secrets:

These are used during build time:

- `VITE_API_URL` - Already added
- Add others as needed

---

## 🎯 Next Steps

After successful deployment:

1. ✅ Set up custom domain (optional)
2. ✅ Enable HTTPS (automatic with Azure)
3. ✅ Configure CORS for backend communication
4. ✅ Set up monitoring and alerts
5. ✅ Scale up from Free tier when ready

---

## 📊 Checking Deployment Status

### Via Azure Portal

https://portal.azure.com > App Services > ripper > Deployment Center

### Via CLI

```bash
# Check app status
az webapp show --name ripper --resource-group ripper-erp-frontend-rg --query state

# Get app URL
az webapp show --name ripper --resource-group ripper-erp-frontend-rg --query defaultHostName -o tsv
```

---

## 🆘 Need Help?

Common issues and solutions:

### Issue: "Application Error" on website

**Solution**: Check startup command and ensure `dist` folder exists

### Issue: GitHub Actions fails at build

**Solution**: Check if `npm run build` works locally

### Issue: GitHub Actions fails at deploy

**Solution**: Verify publish profile secret is correctly added

### Issue: 404 errors for routes

**Solution**: Add URL rewrite rules (we've included this in startup.sh)

---

## 📞 Support Resources

- Azure Web App Docs: https://docs.microsoft.com/en-us/azure/app-service/
- GitHub Actions: https://docs.github.com/en/actions
- Refine Docs: https://refine.dev/docs/

---

## ✅ Deployment Checklist

- [x] Azure Web App created
- [ ] Publish profile downloaded
- [ ] GitHub secret `AZURE_WEBAPP_PUBLISH_PROFILE` added
- [ ] GitHub secret `VITE_API_URL` added
- [ ] Azure app settings configured
- [ ] Startup command set
- [ ] Code pushed to GitHub
- [ ] Deployment successful
- [ ] App accessible at ripper.azurewebsites.net
- [ ] All routes working correctly

---

**Current Status**: ⏳ Waiting for publish profile to be added to GitHub Secrets

**Next Action**: Download publish profile and add to GitHub Secrets (Step 2)
