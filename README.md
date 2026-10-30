# DATA 607 — Week 9: Working with Web APIs

## Project Overview

This project uses the New York Times Books API to collect and explore bestseller data from the Hardcover Fiction category.

The goal is to practice working with web APIs, JSON data, R, and SQLite databases.

## Research Questions

1. What are the top five bestselling hardcover fiction books?
2. Which authors appear on the bestseller list?
3. How many weeks have the top books been on the list?

## Tools and Technologies

- R and RStudio
- Quarto
- New York Times Books API
- JSON and CSV
- SQLite
- R packages: `httr`, `jsonlite`, `dplyr`, `DBI`, `RSQLite`, and `knitr`

## Project Files

- `DATA 607 — Week 9: Working with Web APIs.qmd` — Project Approach and R code.
- `DATA 607 — Week 9: Working with Web APIs.html` — Rendered report.
- `fetch_nyt_books.R` — API data collection script.
- `data/nyt_hardcover_fiction_raw.json` — Original API response.
- `data/nyt_hardcover_fiction.csv` — Organized dataset.
- `data/nyt_books.sqlite` — SQLite database.

## Preliminary Results

The dataset contains 15 books from the Hardcover Fiction bestseller list.

The project includes API data collection, JSON processing, database creation, data cleaning, and preliminary analysis of book rankings and weeks on the bestseller list.

## Published Approach

[View the Week 9 Approach on RPubs](https://rpubs.com/howtwo3/DATA607-Week9-NYT-Books-API)

## AI Use

ChatGPT was used to help organize the project, improve English writing, and provide guidance on API requests, JSON processing, SQLite, and data validation.

The API key is stored separately in an environment variable and is not included in this repository.
