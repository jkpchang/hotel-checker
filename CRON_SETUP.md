# Hotel Availability Checker - Cron Setup

This document explains how to set up a cron job to automatically run the hotel availability checker every day at 5:42 PM.

## Files Created

1. **`run_checker.sh`** - The main script that cron will execute
2. **`setup_cron.sh`** - Helper script to set up the cron job
3. **`CRON_SETUP.md`** - This documentation file

## Quick Setup

### Step 1: Set Environment Variables

First, set your Gmail credentials and recipient email:

```bash
export GMAIL_USER="your-email@gmail.com"
export GMAIL_PASSWORD="your-app-password"
export TO_EMAIL="recipient@example.com"
```

To make these permanent, add them to your shell profile (`~/.zshrc` or `~/.bash_profile`):

```bash
echo 'export GMAIL_USER="your-email@gmail.com"' >> ~/.zshrc
echo 'export GMAIL_PASSWORD="your-app-password"' >> ~/.zshrc
echo 'export TO_EMAIL="recipient@example.com"' >> ~/.zshrc
source ~/.zshrc
```

### Step 2: Run the Setup Script

```bash
./setup_cron.sh
```

This script will:
- Check if all required files exist
- Verify environment variables are set
- Add the cron job to run every day at 5:42 PM
- Show you the updated crontab

## Manual Setup

If you prefer to set up cron manually:

1. **Edit your crontab**:
   ```bash
   crontab -e
   ```

2. **Add this line**:
   ```
   42 17 * * * /Users/jchang/work/jc-checker/hotel/run_checker.sh
   ```

3. **Save and exit** (usually Ctrl+X, then Y, then Enter in nano)

## Cron Job Details

- **Schedule**: Every day at 5:45 PM (17:45)
- **Script**: `/Users/jchang/work/jc-checker/hotel/run_checker.sh`
- **Binary**: `/Users/jchang/work/jc-checker/hotel/hotel_checker`
- **Logs**: `~/hotel_checker.log`
- **Dates**: Currently set to check March 22-24, 2026

## Customizing the Dates

To change the dates being checked, edit `run_checker.sh` and modify these lines:

```bash
CHECK_IN_DATE="2024-12-25"  # Change this
CHECK_OUT_DATE="2024-12-27"  # Change this
```

## Monitoring

### Check if cron is running:
```bash
ps aux | grep cron
```

### View cron logs:
```bash
tail -f ~/hotel_checker.log
```

### View your crontab:
```bash
crontab -l
```

### Test the script manually:
```bash
./run_checker.sh
```

## Troubleshooting

### Common Issues:

1. **"Go was prevented from modifying"** - ✅ **FIXED**: Now uses pre-compiled binary instead of `go run`
2. **"Environment variables not set"** - Set GMAIL_USER, GMAIL_PASSWORD, and TO_EMAIL in crontab
3. **"Permission denied"** - Make sure the script is executable: `chmod +x run_checker.sh`
4. **Cron not running** - Check if cron daemon is active: `sudo launchctl list | grep cron`
5. **Binary not found** - Rebuild with: `./build.sh`

### Check cron daemon status:
```bash
sudo launchctl list | grep cron
```

If cron is not running, start it:
```bash
sudo launchctl load -w /System/Library/LaunchDaemons/com.vix.cron.plist
```

## Removing the Cron Job

To remove the cron job:

```bash
crontab -e
```

Then delete the line that contains `run_checker.sh` and save the file.

## Cron Format Explained

The cron job `42 17 * * *` means:
- `42` - Minute (42)
- `17` - Hour (17 = 5 PM)
- `*` - Day of month (every day)
- `*` - Month (every month)
- `*` - Day of week (every day of week)

## Alternative Schedules

- **Every hour**: `0 * * * *`
- **Every 30 minutes**: `*/30 * * * *`
- **Weekdays only**: `42 17 * * 1-5`
- **Twice daily**: `42 9,17 * * *` (9:42 AM and 5:42 PM)
