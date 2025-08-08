package main

import (
	"context"
	"fmt"
	"log"
	"net/smtp"
	"os"
	"strings"
	"time"

	"github.com/chromedp/chromedp"
)



// Config holds the application configuration
type Config struct {
	GmailUser     string
	GmailPassword string
	ToEmail       string
}

// HotelChecker handles hotel availability checking
type HotelChecker struct {
	config Config
}

// NewHotelChecker creates a new HotelChecker instance
func NewHotelChecker(config Config) *HotelChecker {
	return &HotelChecker{
		config: config,
	}
}

// Calculate length of stay in days
func calculateLOS(checkIn, checkOut string) (int, error) {
	checkInDate, err := time.Parse("2006-01-02", checkIn)
	if err != nil {
		return 0, fmt.Errorf("invalid check-in date: %w", err)
	}
	
	checkOutDate, err := time.Parse("2006-01-02", checkOut)
	if err != nil {
		return 0, fmt.Errorf("invalid check-out date: %w", err)
	}
	
	los := int(checkOutDate.Sub(checkInDate).Hours() / 24)
	return los, nil
}

// CheckAvailability checks if the specific room is available using headless Chrome
func (hc *HotelChecker) CheckAvailability(checkIn, checkOut string) (bool, error) {
	log.Printf("Checking availability using headless Chrome...")
	
	// Calculate length of stay
	los, err := calculateLOS(checkIn, checkOut)
	if err != nil {
		return false, err
	}
	
	log.Printf("Length of stay: %d days", los)
	
	// Construct the direct booking URL
	baseURL := "https://olympicvillageinn.book.pegsbe.com/rooms"
	params := fmt.Sprintf("?CheckinDate=%s&LOS=%d&Rooms=1&Adults_1=1&locale=en&offerCode=", checkIn, los)
	fullURL := baseURL + params
	
	log.Printf("Checking availability at: %s", fullURL)
	
	// Create headless Chrome context with reduced logging
	ctx, cancel := chromedp.NewContext(
		context.Background(),
		chromedp.WithLogf(func(s string, args ...interface{}) {
			// Only log important messages, ignore parsing errors
			if !strings.Contains(s, "could not unmarshal event") {
				log.Printf(s, args...)
			}
		}),
	)
	defer cancel()
	
	// Set timeout
	ctx, cancel = context.WithTimeout(ctx, 30*time.Second)
	defer cancel()
	
	// Navigate to the page and wait for it to load
	var pageText string
	err = chromedp.Run(ctx,
		chromedp.Navigate(fullURL),
		chromedp.Sleep(5*time.Second), // Wait for JavaScript to load
		chromedp.Text("body", &pageText),
	)
	
	if err != nil {
		return false, fmt.Errorf("failed to load page: %w", err)
	}
	
	log.Printf("Page loaded successfully, content length: %d characters", len(pageText))
	
	// Search for the specific room type - "One Bedroom Deluxe Suite"
	roomType := "One Bedroom Deluxe Suite"
	
	if strings.Contains(pageText, roomType) {
		log.Printf("Found room type: %s", roomType)
		return true, nil
	}

	log.Printf("Room type '%s' not found or not available", roomType)
	return false, nil
}

// SendEmail sends an email notification using Gmail SMTP
func (hc *HotelChecker) SendEmail(subject, message string) error {
	// Gmail SMTP settings
	from := hc.config.GmailUser
	to := []string{hc.config.ToEmail}
	
	// Gmail SMTP server
	smtpHost := "smtp.gmail.com"
	smtpPort := "587"
	
	// Create the email message
	emailBody := fmt.Sprintf("From: %s\r\nTo: %s\r\nSubject: %s\r\n\r\n%s", 
		from, hc.config.ToEmail, subject, message)
	
	// Authenticate and send
	auth := smtp.PlainAuth("", from, hc.config.GmailPassword, smtpHost)
	
	err := smtp.SendMail(smtpHost+":"+smtpPort, auth, from, to, []byte(emailBody))
	if err != nil {
		return fmt.Errorf("failed to send email: %w", err)
	}
	
	log.Printf("Email sent successfully")
	return nil
}

// RunCheck orchestrates the availability check and email notification
func (hc *HotelChecker) RunCheck(checkIn, checkOut string) (bool, error) {
	log.Printf("Checking availability for %s to %s", checkIn, checkOut)
	
	available, err := hc.CheckAvailability(checkIn, checkOut)
	if err != nil {
		return false, fmt.Errorf("failed to check availability: %w", err)
	}

	if available {
		log.Printf("Room is available! Sending email notification...")
		subject := "Hotel Room Available!"
		message := fmt.Sprintf("Olympic Village Inn One Bedroom Deluxe Suite is available for %s to %s", checkIn, checkOut)
		err = hc.SendEmail(subject, message)
		if err != nil {
			return true, fmt.Errorf("room available but failed to send email: %w", err)
		}
		return true, nil
	} else {
		log.Printf("Room is not available")
		return false, nil
	}
}

func main() {
	log.Printf("Starting hotel availability check...")

	// Check if date ranges file exists
	dateRangesFile := "date_ranges.txt"
	if _, err := os.Stat(dateRangesFile); os.IsNotExist(err) {
		log.Fatalf("Date ranges file not found: %s", dateRangesFile)
	}

	// Read date ranges from file
	dateRanges, err := readDateRanges(dateRangesFile)
	if err != nil {
		log.Fatalf("Error reading date ranges: %v", err)
	}

	log.Printf("Found %d date ranges to check", len(dateRanges))

	// Validate Gmail environment variables
	gmailUser := os.Getenv("GMAIL_USER")
	gmailPassword := os.Getenv("GMAIL_PASSWORD")
	toEmail := os.Getenv("TO_EMAIL")

	if gmailUser == "" || gmailPassword == "" || toEmail == "" {
		log.Fatal("Missing required environment variables. Please set GMAIL_USER, GMAIL_PASSWORD, and TO_EMAIL")
	}

	config := Config{
		GmailUser:     gmailUser,
		GmailPassword: gmailPassword,
		ToEmail:       toEmail,
	}

	checker := NewHotelChecker(config)

	// Check each date range
	availableRanges := []string{}
	for _, dateRange := range dateRanges {
		log.Printf("Checking availability for %s to %s", dateRange.checkIn, dateRange.checkOut)
		
		available, err := checker.RunCheck(dateRange.checkIn, dateRange.checkOut)
		if err != nil {
			log.Printf("Error checking %s to %s: %v", dateRange.checkIn, dateRange.checkOut, err)
			continue
		}
		
		if available {
			availableRanges = append(availableRanges, fmt.Sprintf("%s to %s", dateRange.checkIn, dateRange.checkOut))
		}
	}

	if len(availableRanges) > 0 {
		log.Printf("Found availability for %d date range(s): %v", len(availableRanges), availableRanges)
	} else {
		log.Printf("No availability found for any date ranges")
	}

	log.Printf("Check completed successfully")
}

// DateRange represents a check-in and check-out date pair
type DateRange struct {
	checkIn  string
	checkOut string
}

// readDateRanges reads date ranges from a file
func readDateRanges(filename string) ([]DateRange, error) {
	content, err := os.ReadFile(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to read file: %w", err)
	}

	lines := strings.Split(string(content), "\n")
	var dateRanges []DateRange

	for i, line := range lines {
		line = strings.TrimSpace(line)
		
		// Skip empty lines and comments
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		parts := strings.Split(line, ",")
		if len(parts) != 2 {
			log.Printf("Warning: Invalid format on line %d: %s", i+1, line)
			continue
		}

		checkIn := strings.TrimSpace(parts[0])
		checkOut := strings.TrimSpace(parts[1])

		// Validate date format (YYYY-MM-DD)
		if !isValidDate(checkIn) || !isValidDate(checkOut) {
			log.Printf("Warning: Invalid date format on line %d: %s", i+1, line)
			continue
		}

		dateRanges = append(dateRanges, DateRange{
			checkIn:  checkIn,
			checkOut: checkOut,
		})
	}

	return dateRanges, nil
}

// isValidDate checks if a string is in YYYY-MM-DD format
func isValidDate(date string) bool {
	if len(date) != 10 {
		return false
	}
	
	// Check if it's in YYYY-MM-DD format
	if date[4] != '-' || date[7] != '-' {
		return false
	}
	
	// Try to parse the date
	_, err := time.Parse("2006-01-02", date)
	return err == nil
}
