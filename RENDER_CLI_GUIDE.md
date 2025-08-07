# Render CLI Deployment Guide

## ✅ **Quick Deployment with Render CLI**

Since you're already logged in to Render CLI, here are the steps to deploy your hotel checker:

## **Option 1: Manual Dashboard Setup (Recommended)**

1. **Go to Render Dashboard**: https://dashboard.render.com
2. **Create New Service**: Click "New +" → "Cron Job"
3. **Connect Repository**: Link your GitHub repository
4. **Configure Settings**:
   - **Build Command**: `go build -o hotel-checker`
   - **Start Command**: `./hotel-checker 2025-12-22 2025-12-25`
   - **Schedule**: `*/30 * * * *` (every 30 minutes)

5. **Add Environment Variables**:
   - `GMAIL_USER`: your-email@gmail.com
   - `GMAIL_PASSWORD`: your-16-char-app-password
   - `TO_EMAIL`: recipient@example.com

6. **Create Service**: Click "Create Cron Job"

## **Option 2: Use the Deployment Script**

Run the automated deployment script:

```bash
./deploy_to_render.sh
```

This will:
- ✅ Check Render CLI installation
- ✅ Verify login status
- ✅ Prompt for Gmail credentials
- ✅ Configure schedule
- ✅ Create render.yaml file
- ✅ Guide you through dashboard setup

## **Option 3: Render CLI Commands**

Once your service is created, you can use these CLI commands:

```bash
# List all services
render services

# View service logs
render logs [SERVICE_ID]

# Trigger a manual deploy
render deploys create [SERVICE_ID]

# Check service status
render services --output json --confirm
```

## **Monitoring Your Deployment**

### **Success Indicators**
- ✅ Service shows "Live" status in dashboard
- ✅ Logs show "Page loaded successfully"
- ✅ Logs show "Found room type: One Bedroom Deluxe Suite"
- ✅ Email notifications are received

### **Troubleshooting**
- ❌ **Build fails**: Check Go version compatibility
- ❌ **Email errors**: Verify Gmail App Password
- ❌ **Room not found**: Check if hotel website changed
- ❌ **Rate limiting**: Shouldn't happen with direct booking site

## **Useful Render CLI Commands**

```bash
# Get service ID
render services --output json --confirm

# View recent logs
render logs [SERVICE_ID] --output text

# Trigger manual run
render deploys create [SERVICE_ID] --output json --confirm

# Check service health
render services --output json --confirm | jq '.[] | {name: .name, status: .status}'
```

## **Schedule Options**

- **Every 30 minutes**: `*/30 * * * *` (recommended)
- **Every hour**: `0 * * * *`
- **Every 2 hours**: `0 */2 * * *`
- **Twice daily**: `0 */12 * * *`

## **Cost Considerations**

- **Free Tier**: 750 hours/month
- **Cron Job**: ~720 hours/month (30 days × 24 hours)
- **Result**: Fits within free tier! 🎉

## **Next Steps**

1. **Run the deployment script**: `./deploy_to_render.sh`
2. **Follow the dashboard setup** (if using script)
3. **Test with real Gmail credentials**
4. **Monitor logs for successful operation**
5. **Adjust schedule as needed**

Your hotel checker will automatically run and send email notifications when the room becomes available! 🏨📧
