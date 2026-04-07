SELECT
    player_name,
    competition,
    innings,
    total_runs,
    total_fours,
    total_sixes,
    boundary_pct,
    sixes_per_innings
FROM player_metrics
WHERE innings >= 6
ORDER BY boundary_pct DESC, sixes_per_innings DESC
LIMIT 30;