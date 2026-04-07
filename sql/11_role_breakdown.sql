SELECT
    player_name,
    competition,
    innings,
    total_runs,
    avg_runs,
    strike_rate,
    batting_index,
    CASE
        WHEN strike_rate >= 170 THEN 'Explosive Finisher'
        WHEN avg_runs >= 40 AND strike_rate < 140 THEN 'Anchor'
        WHEN avg_runs >= 30 AND strike_rate >= 145 THEN 'Aggressive Top Order'
        WHEN strike_rate >= 150 THEN 'Power Hitter'
        ELSE 'Balanced'
    END AS role
FROM player_metrics
WHERE innings >= 6
ORDER BY competition, role, batting_index DESC;