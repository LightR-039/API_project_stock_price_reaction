/*
===============================================================================
View: vw_stock_trading_calendar
===============================================================================
Purpose:
    - Creates a sequential trading day index for each company based on price dates.
    - Assigns a unique, incremental trading_day_index (starting from 1) per company,
      ordered chronologically by price_date.

Dependencies:
    - fact_stock_prices (columns: company_id, price_date, close_price)

Functions Used:
    - ROW_NUMBER() window function
    - PARTITION BY and ORDER BY in OVER clause
===============================================================================
*/

CREATE VIEW vw_stock_trading_calendar AS
SELECT
    company_id,
    price_date,
    close_price,
    ROW_NUMBER() OVER (
        PARTITION BY company_id
        ORDER BY price_date
    ) AS trading_day_index
FROM fact_stock_prices;
