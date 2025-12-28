/*
===============================================================================
View: vw_stock_daily_returns
===============================================================================
Purpose:
    - Calculates daily stock returns for each company.
    - Provides the previous day's closing price and the simple daily return
      ((close_price - prev_close) / prev_close).

Dependencies:
    - fact_stock_prices (columns: company_id, price_date, close_price)

Functions Used:
    - LAG() window function to access previous close_price
    - Arithmetic calculation for stock_return
    - PARTITION BY and ORDER BY in OVER clause
===============================================================================
*/

CREATE VIEW vw_stock_daily_returns AS
SELECT
    company_id,
    price_date,
    close_price,
    LAG(close_price) OVER (
        PARTITION BY company_id
        ORDER BY price_date
    ) AS prev_close,
    (close_price - LAG(close_price) OVER (
        PARTITION BY company_id
        ORDER BY price_date
    )) / LAG(close_price) OVER (
        PARTITION BY company_id
        ORDER BY price_date
    ) AS stock_return
FROM fact_stock_prices;

