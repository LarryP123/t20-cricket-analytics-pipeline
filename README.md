## Cricket Data Pipeline (T20 Franchise Analytics)

This project is a cricket analytics pipeline built with Python, SQLite, SQLAlchemy, and CricAPI.
It extracts match and scorecard data for major men’s T20 franchise competitions, transforms nested API responses into structured tables, and loads them into a local SQLite database.
On top of this pipeline, a reusable analytics layer is built to generate player performance metrics and leaderboards.
The project is designed as a compact end-to-end ETL portfolio piece.

## Tech Stack 

Python, SQLite, SQLAlchemy, REST API (CricAPI)

## Data Coverage 

- Indian Premier League (IPL 2025)
- Big Bash League (BBL 2024–25)
- Caribbean Premier League (CPL 2025)

## Pipeline Overview

Extract
Fetches series, matches, and scorecards via CricAPI
Transform
Normalises match, innings, batting, and bowling data
Derives competition and season metadata
Load
Stores data in a relational SQLite database using upserts

## Analytics Layer

SQL-based transformations are applied on top of the raw dataset to produce:
- Player aggregates (runs, balls, strike rate)
- Derived metrics (batting index, impact score)
- Ranked leaderboards

All analytics queries are modular and reusable.

## Player Performance Metrics

| Metric                     | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| Boundary Hitters         | % of runs scored from 4s and 6s (measures power hitting)                    |
| Impactful Players        | Combines run output and strike rate                                         |
| Batting Index            | Runs × Strike Rate (overall attacking value)                                |
| Consistency + Aggression | Players who score consistently at high tempo                                |
| High-Volume Batters      | Players with large run totals                                               |
| Explosive Hitters        | High strike rate + six hitting ability                                      |
| Reliable Anchors         | Consistent scorers with controlled strike rates                             |

## Further Metric Explination: Batting Index

Batting Index is designed to capture **overall attacking value**:

Batting Index = Runs × Strike Rate

This rewards players who:
- Score heavily (volume)
- Score quickly (impact)

Unlike averages, this reflects **match-winning contribution in T20 cricket**.

## Exporting Results

```bash
python -m src.export_leaderboards
```
### Output Files

| File Name                        | Description                    |
|--------------------------------|--------------------------------|
| 01_boundary_hitters.csv        | Power hitting leaderboard      |
| 02_impactful_players.csv       | Combined output + strike rate  |
| 03_batting_index.csv           | Overall attacking value        |
| 04_consistency_aggression.csv  | Consistency + tempo            |
| 05_high_volume_batters.csv     | Run accumulation               |
| 06_explosive_hitters.csv       | Strike rate + six hitting      |
| 07_reliable_anchors.csv        | Stable scoring players         |

## Project Structure

src/
  extract.py        # API calls
  transform.py      # Data cleaning & modelling
  load.py           # Database loading (SQLite)
  export_leaderboards.py

sql/
  *.sql             # Analytics queries

data/
  cricket.db        # SQLite database

exports/
  *.csv             # Generated leaderboards

## How To Run

```bash
export CRICKETDATA_API_KEY="your_api_key_here"
python -m src.main
python -m src.export_leaderboards
```

## Example Outputs

These outputs demonstrate how raw match and scorecard data can be transformed into meaningful player insights.

Rather than relying on traditional statistics alone, the analysis highlights different dimensions of T20 batting performance:
- **Volume** (run accumulation)
- **Impact** (match-winning innings)
- **Efficiency** (strike rate)
- **Role-based value** (anchors vs explosive hitters)

Together, these tables show how players contribute in different ways, and how modern T20 performance can be better understood through a combination of metrics.

This analysis focuses on three major T20 franchise competitions:

- **Indian Premier League (IPL)** — the highest standard of T20 cricket, featuring the world’s best players and the most competitive environments  
- **Big Bash League (BBL)** — a balanced competition with a mix of international stars and domestic talent  
- **Caribbean Premier League (CPL)** — known for its aggressive, power-hitting style of play  

Together, these competitions provide a diverse dataset, allowing player performance to be evaluated across different conditions, playing styles, and levels of competition.

### Matches By Competition

| Competition | Season  | Matches |
| ----------- | ------- | ------- |
| IPL         | 2025    | 75      |
| BBL         | 2024–25 | 44      |
| CPL         | 2025    | 34      |

## Top Run Scorers 

| Rank | Player            | Runs |
| ---- | ----------------- | ---- |
| 1    | Sai Sudharsan     | 738  |
| 2    | Suryakumar Yadav  | 717  |
| 3    | Virat Kohli       | 657  |
| 4    | Shubman Gill      | 615  |
| 5    | Shreyas Iyer      | 604  |
| 6    | Prabhsimran Singh | 599  |
| 7    | Yashasvi Jaiswal  | 559  |
| 8    | Mitchell Marsh    | 552  |
| 9    | Priyansh Arya     | 545  |
| 10   | KL Rahul          | 539  |

**Insight:**  
Run accumulation is dominated by top-order players, with Sai Sudharsan and Suryakumar Yadav leading the charts.  
However, high run totals alone do not indicate impact — many of these players combine volume with strong strike rates, making them both consistent and aggressive contributors.

### Highest Individual Scores (Single Match)

| Player            | Team                     | Runs | Balls | Strike Rate |
|------------------|--------------------------|------|-------|------------|
| Abhishek Sharma  | Sunrisers Hyderabad      | 141  | 55    | 256.36     |
| Tim Seifert      | Saint Lucia Kings        | 125  | 53    | 235.85     |
| Steven Smith     | Sydney Sixers            | 121  | 64    | 189.06     |
| Colin Munro      | Trinbago Knight Riders   | 120  | 57    | 210.53     |
| Rishabh Pant     | Lucknow Super Giants     | 118  | 61    | 193.44     |

**Insight:**  
The highest individual scores are characterised by extremely high strike rates, with multiple innings exceeding 200 SR.  
This highlights the increasing importance of **explosive innings** in T20 cricket, where a single performance can heavily influence match outcomes.

### Best Batting Index (Overall Performance)

| Rank | Player            | Runs | SR    | Batting Index |
|------|------------------|------|-------|----------------|
| 1    | Nicholas Pooran  | 927  | 160.9 | 1491.9         |
| 2    | Suryakumar Yadav | 717  | 167.9 | 1204.0         |
| 3    | Sai Sudharsan    | 738  | 157.0 | 1158.8         |

**Insight:**  
Nicholas Pooran ranks highest due to a rare combination of **very high run volume and elite strike rate**, making him the most impactful batter overall.  
This metric rewards players who contribute both consistently and aggressively, rather than excelling in only one dimension.

## Most Explosive Hitters

| Rank | Player           | SR    | 6s |
| ---- | ---------------- | ----- | -- |
| 1    | Tim David        | 170.9 | 36 |
| 2    | Andre Russell    | 168.5 | 30 |
| 3    | Suryakumar Yadav | 167.9 | 32 |

**Insight:**  
Explosive hitters are defined by their ability to score rapidly, often through six hitting.  
Players like Tim David and Andre Russell stand out as **finisher-type batters**, delivering high-impact performances in shorter innings.

## Reliable Anchors

| Rank | Player        | Runs | Avg  | SR    |
| ---- | ------------- | ---- | ---- | ----- |
| 1    | Sai Sudharsan | 738  | 52.7 | 157.0 |
| 2    | Virat Kohli   | 657  | 48.2 | 145.3 |
| 3    | Shubman Gill  | 615  | 44.0 | 149.5 |

**Insight:**  
Reliable anchors provide stability by combining high averages with controlled strike rates.  
Players such as Sai Sudharsan demonstrate that it is possible to maintain consistency **without sacrificing scoring tempo**, making them highly valuable in modern T20 lineups.

## Comclusion

This project demonstrates how raw sports data can be transformed into structured, insight-driven analytics to better evaluate player performance in modern T20 cricket.

