package main

import (
	"fmt"
	"os"
	"time"
)

func parseArgs() (int, error) {
	startdateS := os.Args[1]
	enddateS := os.Args[2]

	startdate, err := time.Parse("2006010215", startdateS)
	if err != nil {
		fmt.Printf("Cannot parse startdate argument. You must use YYYYMMDDHH format.")
		return 0, err
	}

	enddate, err := time.Parse("2006010215", enddateS)
	if err != nil {
		fmt.Printf("Cannot parse enddate argument. You must use YYYYMMDDHH format.")
		return 0, err
	}

	lenghtHours := int(enddate.Sub(startdate) / time.Hour)

	return lenghtHours, nil
}

func main() {
	if len(os.Args) < 3 {
		fmt.Printf("Usage: needs-constants startdate enddate; echo $?\n")
		fmt.Printf("\twhere startdate and enddate are in format YYYYMMDDHH\n\n")
		os.Exit(-1)
	}

	hours, err := parseArgs()
	if err != nil {
		os.Exit(-1)
	}

	if hours > 24 {
		os.Exit(0) // Bash TRUE: we need TAVGSFC file
	}

	os.Exit(1)

}
