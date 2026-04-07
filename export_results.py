import sqlite3
import pandas as pd
import os

DB_PATH = "data/cricket.db"
CREATE_SQL = "sql/00_create_analytics_layer.sql"

SQL_FILES = {
    "01_best_overall_batters": "sql/01_best_overall_batters.sql",
    "02_best_by_league": "sql/02_best_by_league.sql",
    "03_high_volume_batters": "sql/03_high_volume_batters.sql",
    "04_efficiency_plus_aggression": "sql/04_efficiency_plus_aggression.sql",
    "05_boundary_hitters": "sql/05_boundary_hitters.sql",
    "06_explosive_hitters": "sql/06_explosive_hitters.sql",
    "07_reliable_anchors": "sql/07_reliable_anchors.sql",
    "08_underrated_players": "sql/08_underrated_players.sql",
    "09_multi_league_performers": "sql/09_multi_league_performers.sql",
    "10_league_environment": "sql/10_league_environment.sql",
    "11_role_breakdown": "sql/11_role_breakdown.sql",
    "12_most_consistent_players": "sql/12_most_consistent_players.sql",
}

OUTPUT_DIR = "exports"
os.makedirs(OUTPUT_DIR, exist_ok=True)

conn = sqlite3.connect(DB_PATH)
cur = conn.cursor()

with open(CREATE_SQL, "r") as f:
    cur.executescript(f.read())

conn.commit()

for name, path in SQL_FILES.items():
    try:
        with open(path, "r") as f:
            query = f.read()
        df = pd.read_sql_query(query, conn)
        df.to_csv(os.path.join(OUTPUT_DIR, f"{name}.csv"), index=False)
        print(f"Saved {name}.csv")
    except Exception as e:
        print(f"Failed {name}: {e}")

conn.close()