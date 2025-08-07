# Hotel Availability Checker

A Go program that checks the Olympic Village Inn's direct booking site for the availability of "One Bedroom Deluxe Suite" and sends email notifications via Gmail SMTP when available.

## Features

- Checks Olympic Village Inn direct booking site for specific room availability
- Sends email notifications via Gmail SMTP when room is found
- Configurable date ranges for testing
- Designed for deployment on Render

## Prerequisites

- Go 1.21 or later
- Gmail account with 2-Factor Authentication enabled
- App Password generated for SMTP access

## Setup

### 1. Install Dependencies

```bash
go mod tidy
```

### 2. Gmail Configuration

You'll need the following Gmail credentials:
- **Gmail User**: Your Gmail address
- **Gmail Password**: Your 16-character App Password (not your regular password)
- **To Email**: Email address to receive notifications

See `GMAIL_SETUP.md` for detailed setup instructions.

### 3. Environment Variables

#### For Local Testing:
Set the following environment variables:

```bash
export GMAIL_USER="your-email@gmail.com"
export GMAIL_PASSWORD="your-16-char-app-password"
export TO_EMAIL="recipient@example.com"
```

#### For Render Deployment:
Add these in your Render dashboard under "Environment" tab:
- `GMAIL_USER` = your-email@gmail.com
- `GMAIL_PASSWORD` = your-16-char-app-password
- `TO_EMAIL` = recipient@example.com

**Security Note:** Render environment variables are encrypted and never exposed to your GitHub repository.

## Usage

### Local Testing

1. **Default dates (Dec 22-25, 2025):**
   ```bash
   go run main.go
   ```

2. **Custom date range:**
   ```bash
   go run main.go 2025-12-20 2025-12-23
   ```

3. **Build and run:**
   ```bash
   go build -o hotel-checker
   ./hotel-checker
   ```

### Testing Different Date Ranges

To test with different dates, simply provide them as command line arguments:

```bash
# Test for January dates
go run main.go 2025-01-15 2025-01-18

# Test for February dates  
go run main.go 2025-02-10 2025-02-13
```

## How It Works

1. **URL Construction**: The program constructs the hotel's direct booking URL with the specified parameters
2. **Web Scraping**: Uses headless Chrome to load JavaScript-rendered content and search for the specific room type
3. **Availability Check**: Looks for the room type "One Bedroom Deluxe Suite" and availability indicators
4. **Email Notification**: If the room is available, sends email notification via Gmail SMTP

## Deployment on Render

### 1. Create a Render Account
- Sign up at [render.com](https://render.com)
- Connect your GitHub repository

### 2. Create a New Web Service
- Click "New +" → "Web Service"
- Connect your GitHub repository
- Configure the service:

**Build Command:**
```bash
go mod tidy && go build -o hotel-checker
```

**Start Command:**
```bash
./hotel-checker
```

### 3. Environment Variables
Add these environment variables in Render dashboard under "Environment" tab:
- `GMAIL_USER` = your-email@gmail.com
- `GMAIL_PASSWORD` = your-16-char-app-password
- `TO_EMAIL` = recipient@example.com

**Security:** These are encrypted and never exposed to your GitHub repository.

### 4. Scheduling
To run this as a scheduled job:
- Create a new "Cron Job" service instead of "Web Service"
- Set the schedule (e.g., every hour: `0 * * * *`)
- Use the same build and start commands

## Troubleshooting

### Common Issues

1. **"Room not found"**: The room type text might have changed on Expedia. Check the actual page content.

2. **Email not sending**: Verify your Gmail credentials and App Password setup.

3. **Rate limiting**: Expedia may block requests if too frequent. Consider adding delays between checks.

4. **HTML parsing issues**: Expedia's page structure may change. The program uses simple text matching.

### Debug Mode

To see more detailed output, the program logs all steps. Check the logs for:
- URL being accessed
- Room type search results
- SMS sending status

## File Structure

```
hotel/
├── main.go          # Main program
├── go.mod           # Go module file
└── README.md        # This file
```

## Dependencies

- `github.com/chromedp/chromedp`: Headless Chrome automation

## Notes

- This is a basic implementation that may need adjustments based on the hotel's actual page structure
- The room availability detection is simplified and may need refinement
- Consider implementing more sophisticated parsing for production use
- Uses the hotel's direct booking site to avoid rate limiting issues
