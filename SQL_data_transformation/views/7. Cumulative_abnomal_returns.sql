/*
===============================================================================
View: vw_cumulative_abnormal_returns
===============================================================================
Purpose:
    - Calculates the running cumulative abnormal return (CAR) within each earnings event window.
    - cumulative_abnormal_return is the sum of abnormal returns from the start of the window
      (event_day = -3) up to the current event_day.

Dependencies:
    - vw_abnormal_returns (columns: company_id, symbol, earnings_date,
      event_day, abnormal_return)

Functions Used:
    - SUM() as a window function (cumulative sum)
    - PARTITION BY company_id and earnings_date
    - ORDER BY event_day with ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
===============================================================================
*/

CREATE VIEW vw_cumulative_abnormal_returns AS
SELECT
    company_id,
    symbol,
    earnings_date,
    event_day,
    abnormal_return,
    SUM(abnormal_return) OVER (
        PARTITION BY company_id, earnings_date
        ORDER BY event_day
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_abnormal_return
FROM vw_abnormal_returns;
