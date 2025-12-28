/*
===============================================================================
View: vw_tableau_analysis
===============================================================================
Purpose:
    - Provides a ready-to-use dataset for Tableau visualization of earnings event studies.
    - Includes daily prices, returns, abnormal returns, and running cumulative abnormal returns (CAR)
      in the ±3 day window around earnings announcements.
    - Adds window labels (Pre-Earnings, Earnings Day, Post-Earnings) and key earnings fundamentals (revenue, EPS).

Dependencies:
    - vw_earnings_event_window (columns: symbol, earnings_date, price_date,
      event_day, close_price, company_id)
    - vw_stock_daily_returns (columns: company_id, price_date, stock_return)
    - vw_market_daily_returns (columns: price_date, market_return, close_price,
      index_symbol = '^IXIC')
    - fact_earnings (columns: company_id, earnings_date, revenue, eps)

Functions Used:
    - Multi-table JOIN
    - Arithmetic for abnormal_return
    - SUM() window function for running cumulative_abnormal_return
    - CASE statement for window_label
===============================================================================
*/

CREATE OR ALTER VIEW vw_tableau_analysis AS
SELECT
    ew.symbol,
    ew.earnings_date,
    ew.price_date,
    ew.event_day,

    -- Price
    ew.close_price,
    mr.close_price AS market_close_price,

    -- Returns
    sr.stock_return,
    mr.market_return,
    (sr.stock_return - mr.market_return) AS abnormal_return,

    -- Cumulative Abnormal Return
    SUM(sr.stock_return - mr.market_return) OVER (
        PARTITION BY ew.symbol, ew.earnings_date
        ORDER BY ew.event_day
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_abnormal_return,

    -- Window labels 
    CASE
        WHEN ew.event_day < 0 THEN 'Pre-Earnings'
        WHEN ew.event_day = 0 THEN 'Earnings Day'
        ELSE 'Post-Earnings'
    END AS window_label

FROM vw_earnings_event_window ew
JOIN vw_stock_daily_returns sr
    ON ew.company_id = sr.company_id
   AND ew.price_date = sr.price_date
JOIN vw_market_daily_returns mr
    ON ew.price_date = mr.price_date
   AND mr.index_symbol = '^IXIC' 
JOIN fact_earnings e
    ON ew.company_id = e.company_id
   AND ew.earnings_date = e.earnings_date;

