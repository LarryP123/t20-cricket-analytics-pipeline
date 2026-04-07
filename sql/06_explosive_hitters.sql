SELECT
    player_name,
    competition,
    innings,
    total_runs,
    strike_rate,
    sixes_per_innings,
    boundary_pct
FROM player_metrics
WHERE innings >= 6
  AND strike_rate >= 150
ORDER BY strike_rate DESC, sixes_per_innings DESC
LIMIT 30;