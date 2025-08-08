# Hotel Availability Checker

Automatically checks for hotel room availability and sends email notifications when rooms become available.

## Features

- ✅ **Automated checking** - Runs via cron job on your local machine
- ✅ **Multiple date ranges** - Monitor multiple date ranges simultaneously
- ✅ **Email notifications** - Sends Gmail notifications when rooms are available
- ✅ **Headless Chrome** - Uses browser automation to check real-time availability
- ✅ **Configurable dates** - Easy to add/remove date ranges via text file

## Quick Start

### 1. Set Environment Variables

```bash
export GMAIL_USER="your-email@gmail.com"
export GMAIL_PASSWORD="your-app-password"
export TO_EMAIL="recipient@example.com"
```

### 2. Configure Date Ranges

Copy the example file and edit it with your desired dates:

```bash
cp date_ranges.txt.example date_ranges.txt
```

Then edit `date_ranges.txt` to add your desired dates:

```
2026-01-01,2026-01-05
2025-12-21,2025-12-25
```

### 3. Build the Program

```bash
./build.sh
```

### 4. Set Up Cron Job

```bash
./setup_cron.sh
```

This will set up a cron job to run every day at 5:50 PM.

## How It Works

1. **Cron job runs** daily at 5:50 PM
2. **Program reads** date ranges from `date_ranges.txt`
3. **Checks availability** for each date range using headless Chrome
4. **Sends email** if any rooms are available
5. **Logs results** to `~/hotel_checker.log`

## Files

- `main.go` - Main program
- `date_ranges.txt` - Date ranges to monitor
- `run_checker.sh` - Script executed by cron
- `setup_cron.sh` - Sets up the cron job
- `build.sh` - Builds the program
- `CRON_SETUP.md` - Detailed cron setup guide

## Monitoring

### Check logs:
```bash
tail -f ~/hotel_checker.log
```

### View cron job:
```bash
crontab -l
```

### Test manually:
```bash
./hotel_checker
```

## Requirements

- macOS with Go installed
- Gmail account with app password
- Chrome/Chromium browser

## Troubleshooting

See `CRON_SETUP.md` for detailed troubleshooting guide.
