package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
	"text/template"
	"time"
)

type DateArg struct {
	Iso   string
	Year  int
	Month int
	Day   int
	Hour  int
}

type TmplArgs struct {
	MetGridConstants string
	Start            DateArg
	End              DateArg
	Hours            int
}

func parseArgs() (start, end time.Time, hours int) {
	startdateS := os.Args[1]
	enddateS := os.Args[2]

	startdate, err := time.Parse("2006010215", startdateS)
	if err != nil {
		fmt.Printf("Cannot parse startdate argument: %s. You must use YYYYMMDDHH format.", err.Error())
		os.Exit(1)
	}

	enddate, err := time.Parse("2006010215", enddateS)
	if err != nil {
		fmt.Printf("Cannot parse enddate argument: %s. You must use YYYYMMDDHH format.", err.Error())
		os.Exit(1)
	}

	lenghtHours := int(enddate.Sub(startdate) / time.Hour)

	return startdate, enddate, lenghtHours
}

func createTemplateArgs(start, end time.Time, hours int) TmplArgs {
	var args TmplArgs

	if hours > 24 {
		args.MetGridConstants = "constants_name                = 'TAVGSFC',"
	} else {
		args.MetGridConstants = ""
	}
	args.Start.Day = start.Day()
	args.Start.Month = int(start.Month())
	args.Start.Year = start.Year()
	args.Start.Hour = start.Hour()
	args.Start.Iso = start.Format("2006-01-02_15:00:00")

	args.End.Day = end.Day()
	args.End.Month = int(end.Month())
	args.End.Year = end.Year()
	args.End.Hour = end.Hour()
	args.End.Iso = end.Format("2006-01-02_15:00:00")

	args.Hours = hours
	return args
}

func renderTemplate(start, end time.Time, hours int, input string) {
	tmpl, err := template.New("namelist").Parse(input)
	if err != nil {
		fmt.Printf("Error while parsing template: %s", err.Error())
		os.Exit(1)
	}

	args := createTemplateArgs(start, end, hours)

	err = tmpl.Execute(os.Stdout, args)
	if err != nil {
		fmt.Printf("Error while evaluating template: %s", err.Error())
		os.Exit(1)
	}
}

func readStdin() string {
	scanner := bufio.NewScanner(os.Stdin)
	lines := []string{}
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	if scanner.Err() != nil {
		fmt.Printf("Error while reading from stdin: %s", scanner.Err().Error())
		os.Exit(1)
	}

	return strings.Join(lines, "\n")
}

func main() {
	if len(os.Args) < 3 {
		fmt.Printf("Usage: cat templatefile.tmpl > namelist-prepare startdate enddate > file.out\n")
		fmt.Printf("\twhere startdate and enddate are in format YYYYMMDDHH\n\n")
		os.Exit(1)
	}

	startdate, enddate, hours := parseArgs()
	input := readStdin()
	renderTemplate(startdate, enddate, hours, input)
}
