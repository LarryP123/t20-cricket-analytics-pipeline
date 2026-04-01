from __future__ import annotations

import sqlite3
from pathlib import Path
import csv


DB_PATH = Path("data/cricket.db")
SQL_DIR = Path("sql")
EXPORT_DIR = Path("exports")

VIEW_FILE = SQL_DIR / "00_player_metrics.sql"

LEADERBOARD_FILES = [
    "01_boundary_hitters.sql",
    "02_impactful_players.sql",
    "03_batting_index.sql",
    "04_consistency_aggression.sql",
    "05_high_volume_batters.sql",
    "06_explosive_hitters.sql",
    "07_reliable_anchors.sql",
]


def read_sql_file(path: Path) -> str:
    return path.read_text(encoding="utf-8").strip()


def run_view_sql(conn: sqlite3.Connection, sql: str) -> None:
    conn.executescript(sql)


def run_query(conn: sqlite3.Connection, sql: str) -> tuple[list[str], list[tuple]]:
    cursor = conn.execute(sql)
    rows = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    return columns, rows


def export_to_csv(filename: str, columns: list[str], rows: list[tuple]) -> None:
    EXPORT_DIR.mkdir(parents=True, exist_ok=True)
    output_path = EXPORT_DIR / filename

    with output_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(columns)
        writer.writerows(rows)


def main() -> None:
    if not DB_PATH.exists():
        raise FileNotFoundError(f"Database not found: {DB_PATH}")

    if not VIEW_FILE.exists():
        raise FileNotFoundError(f"Missing SQL file: {VIEW_FILE}")

    with sqlite3.connect(DB_PATH) as conn:
        view_sql = read_sql_file(VIEW_FILE)
        run_view_sql(conn, view_sql)

        for sql_file_name in LEADERBOARD_FILES:
            sql_path = SQL_DIR / sql_file_name

            if not sql_path.exists():
                print(f"Skipping missing file: {sql_path}")
                continue

            query_sql = read_sql_file(sql_path)
            columns, rows = run_query(conn, query_sql)

            csv_name = sql_file_name.replace(".sql", ".csv")
            export_to_csv(csv_name, columns, rows)

            print(f"Exported {csv_name}: {len(rows)} rows")

    print("All leaderboard exports completed.")


if __name__ == "__main__":
    main()