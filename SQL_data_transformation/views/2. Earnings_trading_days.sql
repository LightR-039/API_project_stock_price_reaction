/*
===============================================================================
View: vw_earnings_trading_day
===============================================================================
Purpose:
    - Maps each earnings announcement date to the nearest subsequent trading day index.
    - Finds the smallest trading_day_index where price_date >= earnings_date,
      capturing the first trading day on or after the announcement.

Dependencies:
    - fact_earnings (columns: company_id, earnings_date)
    - vw_stock_trading_calendar (columns: company_id, price_date, trading_day_index)

Functions Used:
    - JOIN on company_id and price_date >= earnings_date
    - MIN() aggregation
    - GROUP BY
===============================================================================
*/

CREATE VIEW vw_earnings_trading_day AS
SELECT
    e.company_id,
    e.earnings_date,
    MIN(c.trading_day_index) AS earnings_trading_index
FROM fact_earnings e
JOIN vw_stock_trading_calendar c
    ON e.company_id = c.company_id
   AND c.price_date >= e.earnings_date
GROUP BY
    e.company_id,
    e.earnings_date;
