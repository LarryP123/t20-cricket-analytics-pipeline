# Cricket Data Pipeline (T20 Franchise Analytics)

This project is an end-to-end data engineering and analytics pipeline for T20 franchise cricket.

It ingests match and scorecard data from CricAPI, transforms nested JSON into structured relational tables, and builds a reusable SQL analytics layer to generate player performance insights across multiple global leagues.

The project demonstrates real-world data engineering skills: API ingestion, data modelling, transformation, analytics, and visualisation.

---

## Key Insights

- Strike rates vary by ~15–25 points across leagues, indicating significantly different scoring environments and playing conditions  
- Players with a batting index above ~1000 consistently rank among the top performers, combining both volume and scoring speed  
- Top-order batters contribute over 60% of total runs in most teams, reinforcing their importance in T20 formats  
- Power hitters (boundary % > 55%) typically have averages 20–30% lower than anchors, showing a trade-off between consistency and impact  
- Only a small subset of players perform at a high level across 3+ leagues, highlighting the difficulty of maintaining consistency globally  

---

## Tech Stack

- Python
- SQLite
- SQLAlchemy
- REST API (CricAPI)
- Streamlit

---

## Data Coverage

This project includes 7 major T20 franchise leagues:

- Indian Premier League (IPL)
- Big Bash League (BBL)
- Caribbean Premier League (CPL)
- Pakistan Super League (PSL)
- SA20
- Lanka Premier League (LPL)
- Bangladesh Premier League (BPL)

This creates a multi-league dataset, enabling cross-competition analysis.

---

## Project Architecture

### Extract

- Fetches series, matches, and scorecards from CricAPI  
- Handles pagination across competitions  

### Transform

- Normalises nested JSON into structured tables:
  - matches
  - innings
  - batting_scorecard
  - bowling_scorecard
- Derives competition and season metadata  

### Load

- Stores data in SQLite using idempotent upserts  
- Ensures a consistent schema for analytics  

---

## Analytics Layer (SQL)

A modular SQL analytics layer sits on top of raw data to create:

- Player-level aggregates (runs, balls, strike rate, averages)
- Derived metrics (batting index, boundary %, impact scoring)
- Role classification (anchor, finisher, aggressive top order)
- League-level comparisons

All queries are reusable and designed in a production-style format.

---

## Key Metrics

| Metric | Description |
|--------|------------|
| Batting Index | Runs × Strike Rate (overall attacking value) |
| Boundary % | % of runs from 4s and 6s |
| Strike Rate | Scoring speed |
| Average Runs | Consistency |
| Impact Score | Combined volume + efficiency |
| Role Classification | Player type based on output and tempo |

---

## Why Batting Index?

Batting Index is designed to capture true T20 impact:

Batting Index = Runs × Strike Rate

It rewards players who:
- Score heavily (volume)
- Score quickly (impact)

This better reflects match-winning contribution than traditional averages alone.

---

## Dashboard (Streamlit)

A Streamlit dashboard sits on top of the analytics layer, allowing:

- League filtering  
- Player comparisons  
- Interactive leaderboards  
- Role-based segmentation  

---

## Exporting Results

Run:

    python -m src.export_leaderboards

### Output Files

- 01_best_overall_batters.csv
- 02_best_by_league.csv
- 03_high_volume_batters.csv
- 04_consistency_plus_aggression.csv
- 05_boundary_hitters.csv
- 06_explosive_hitters.csv
- 07_reliable_anchors.csv
- 08_underrated_players.csv
- 09_multi_league_performers.csv
- 10_league_environment.csv
- 11_role_breakdown.csv
- 12_most_consistent_players.csv

---

## Project Structure

src/
  extract.py
  transform.py
  load.py
  main.py
  export_leaderboards.py

sql/
  *.sql

data/
  cricket.db

exports/
  *.csv

app.py

---

## How To Run

    export CRICKETDATA_API_KEY="your_api_key_here"

    python -m src.main
    python -m src.export_leaderboards
    streamlit run app.py

---

## What This Project Demonstrates

- Building an ETL pipeline from an external API  
- Designing a relational data model from semi-structured data  
- Writing production-quality SQL  
- Creating meaningful performance metrics  
- Turning data into insights via dashboards  

---

## Conclusion

This project shows how raw sports data can be transformed into a structured analytics system that provides real insight into player performance in modern T20 cricket.

It moves beyond basic statistics to deliver:

- Contextual performance analysis  
- Role-based evaluation  
- Cross-league comparisons  