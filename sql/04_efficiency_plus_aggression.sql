SELECT
    player_name,
    competition,
    innings,
    total_runs,
    avg_runs,
    strike_rate,
    batting_index,
    ROUND(avg_runs * strike_rate, 2) AS efficiency_score
FROM player_metrics
WHERE innings >= 8
  AND avg_runs >= 25
  AND strike_rate >= 140
ORDER BY efficiency_score DESC
LIMIT 20;