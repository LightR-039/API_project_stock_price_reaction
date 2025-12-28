/*
===============================================================================
View: vw_earnings_summary
===============================================================================
Purpose:
    - Summarizes abnormal returns around earnings announcements.
    - Computes Cumulative Abnormal Returns (CAR) for pre-earnings (-3 to -1),
      post-earnings (0 to +3), and full window (-3 to +3).
    - Calculates average daily absolute abnormal return (volatility measure).

Dependencies:
    - vw_abnormal_returns (columns: company_id, symbol, earnings_date,
      event_day, abnormal_return)

Functions Used:
    - SUM() with conditional CASE
    - AVG() with ABS()
    - GROUP BY
===============================================================================
*/

CREATE VIEW vw_earnings_summary AS
SELECT
    company_id,
    symbol,
    earnings_date,
    SUM(CASE WHEN event_day BETWEEN -3 AND -1 THEN abnormal_return END) AS CAR_pre_earnings,
    SUM(CASE WHEN event_day BETWEEN 0 AND 3 THEN abnormal_return END) AS CAR_post_earnings,
    SUM(abnormal_return) AS CAR_total_window,
    AVG(ABS(abnormal_return)) AS avg_daily_abnormal_volatility
FROM vw_abnormal_returns
GROUP BY
    company_id,
    symbol,
    earnings_date;







