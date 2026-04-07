from src.extract import (
    get_series,
    get_matches_from_series_info,
    get_match_scorecard,
)
from src.load import (
    create_tables,
    load_matches,
    load_innings,
    load_batting_scorecard,
    load_bowling_scorecard,
)
from src.transform import get_competition_metadata, parse_scorecard


TARGET_SERIES_NAMES = {
    "Indian Premier League 2025 (IPL)",
    "Big Bash League 2024-25",
    "Caribbean Premier League 2025",
    "Bangladesh Premier League, 2024-25",
    "Lanka Premier League, 2024",
    "Pakistan Super League, 2024",
    "SA20, 2025",
}

SEARCH_TERMS = [
    "Indian Premier League",
    "Big Bash League",
    "Caribbean Premier League",
    "Bangladesh Premier League",
    "Lanka Premier League",
    "Pakistan Super League",
    "SA20",
]


def collect_target_series():
    all_series = []

    for term in SEARCH_TERMS:
        try:
            results = get_series(term)
            all_series.extend(results)
        except Exception:
            pass  # silent fail

    unique_series = {}
    for series in all_series:
        series_id = series.get("id")
        if series_id:
            unique_series[series_id] = series

    deduped_series = list(unique_series.values())

    filtered_series = [
        series
        for series in deduped_series
        if series.get("name") in TARGET_SERIES_NAMES
    ]

    print(f"\nSeries selected: {len(filtered_series)}")

    return filtered_series


def run():
    filtered_series = collect_target_series()

    if not filtered_series:
        print("No target series found. Check API key or names.")
        return

    print("\nFetching data...\n")

    match_rows = []
    innings_rows = []
    batting_rows = []
    bowling_rows = []

    for series in filtered_series:
        series_id = series.get("id")
        series_name = series.get("name", "")

        try:
            matches = get_matches_from_series_info(series_id)
        except Exception:
            print(f"Failed to fetch matches: {series_name}")
            continue

        print(f"{series_name}: {len(matches)} matches")

        metadata = get_competition_metadata(series_name)

        for match in matches:
            match_id = match.get("id")
            teams = match.get("teams", [])
            team_1 = teams[0] if len(teams) > 0 else None
            team_2 = teams[1] if len(teams) > 1 else None

            match_rows.append(
                {
                    "match_id": match_id,
                    "raw_series_name": series_name,
                    "competition": metadata["competition"],
                    "season_label": metadata["season_label"],
                    "match_date": match.get("date"),
                    "match_type": match.get("matchType"),
                    "team_1": team_1,
                    "team_2": team_2,
                    "venue": match.get("venue"),
                    "result_text": match.get("status"),
                    "status": match.get("status"),
                }
            )

            try:
                scorecard_data = get_match_scorecard(match_id)
                parsed_innings, parsed_batting, parsed_bowling = parse_scorecard(
                    match_id,
                    scorecard_data,
                    team_1,
                    team_2,
                )

                innings_rows.extend(parsed_innings)
                batting_rows.extend(parsed_batting)
                bowling_rows.extend(parsed_bowling)

            except Exception:
                continue  # silently skip bad scorecards

    print("\nData summary:")
    print(f"Matches: {len(match_rows)}")
    print(f"Innings: {len(innings_rows)}")
    print(f"Batting rows: {len(batting_rows)}")
    print(f"Bowling rows: {len(bowling_rows)}")

    if not match_rows:
        print("No data collected. Stopping.")
        return

    create_tables()
    load_matches(match_rows)
    load_innings(innings_rows)
    load_batting_scorecard(batting_rows)
    load_bowling_scorecard(bowling_rows)

    print("\nData successfully loaded into SQLite.")


if __name__ == "__main__":
    run()