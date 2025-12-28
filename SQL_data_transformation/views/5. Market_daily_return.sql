/*
===============================================================================
View: vw_market_daily_returns
===============================================================================
Purpose:
    - Calculates daily returns for market indices (e.g., NASDAQ ^IXIC).
    - Provides previous closing price and simple daily market return
      ((close_price - prev_close) / prev_close).

Dependencies:
    - fact_market_index (columns: index_symbol, price_date, close_price)

Functions Used:
    - LAG() window function to access previous close_price
    - Arithmetic calculation for market_return
    - PARTITION BY and ORDER BY in OVER clause
===============================================================================
*/

CREATE VIEW vw_market_daily_returns AS
SELECT
    index_symbol,
    price_date,
    close_price,
    LAG(close_price) OVER (
        PARTITION BY index_symbol
        ORDER BY price_date
    ) AS prev_close,
    (close_price - LAG(close_price) OVER (
        PARTITION BY index_symbol
        ORDER BY price_date
    )) / LAG(close_price) OVER (
        PARTITION BY index_symbol
        ORDER BY price_date
    ) AS market_return
FROM fact_market_index;
