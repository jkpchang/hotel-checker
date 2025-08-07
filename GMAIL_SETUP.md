# Gmail SMTP Setup Guide

## ✅ **Easy & Free Email Notifications**

Gmail SMTP is much easier to set up than Twilio and completely free! Here's how to configure it:

## **Step 1: Enable 2-Factor Authentication**

1. Go to your Google Account settings: https://myaccount.google.com/
2. Navigate to "Security" → "2-Step Verification"
3. Enable 2-Step Verification if not already enabled

## **Step 2: Generate App Password**

1. Go to Google Account settings: https://myaccount.google.com/
2. Navigate to "Security" → "App passwords"
3. Select "Mail" as the app
4. Select "Other (Custom name)" and name it "Hotel Checker"
5. Click "Generate"
6. **Copy the 16-character password** (e.g., `abcd efgh ijkl mnop`)

## **Step 3: Set Environment Variables**

### **Local Testing:**
```bash
export GMAIL_USER="your-email@gmail.com"
export GMAIL_PASSWORD="your-16-char-app-password"
export TO_EMAIL="recipient@example.com"
```

### **Render Deployment:**
Add these environment variables in your Render dashboard:
- `GMAIL_USER`: your-email@gmail.com
- `GMAIL_PASSWORD`: your-16-char-app-password  
- `TO_EMAIL`: recipient@example.com

## **Step 4: Test the Setup**

```bash
# Test with real credentials
GMAIL_USER="your-email@gmail.com" \
GMAIL_PASSWORD="your-16-char-app-password" \
TO_EMAIL="recipient@example.com" \
go run main.go 2026-03-23 2026-03-26
```

## **Advantages of Gmail SMTP**

✅ **Completely Free** - No charges for sending emails  
✅ **Easy Setup** - Just need Gmail account and app password  
✅ **Reliable** - Gmail's infrastructure is very stable  
✅ **No API Keys** - Uses standard SMTP authentication  
✅ **Instant Delivery** - Emails arrive immediately  

## **Email Format**

**Subject:** "Hotel Room Available!"  
**Body:** "Olympic Village Inn One Bedroom Deluxe Suite is available for 2026-03-23 to 2026-03-26"

## **Security Notes**

- Use App Passwords, never your main Gmail password
- App passwords are 16 characters with spaces
- You can revoke app passwords anytime from Google Account settings
- The app password is only used for SMTP authentication

## **Troubleshooting**

### **"Username and Password not accepted"**
- Make sure you're using an App Password, not your regular Gmail password
- Verify 2-Factor Authentication is enabled
- Check that the email address is correct

### **"Authentication failed"**
- Ensure the App Password is exactly 16 characters
- Try regenerating the App Password
- Make sure you're using the correct Gmail address

## **Migration from Twilio**

If you were using Twilio SMS before:

1. **Remove Twilio dependencies** ✅ (already done)
2. **Set up Gmail App Password** (see steps above)
3. **Update environment variables** (GMAIL_USER, GMAIL_PASSWORD, TO_EMAIL)
4. **Test with real credentials**

The program now sends emails instead of SMS - much simpler and free! 🎉
