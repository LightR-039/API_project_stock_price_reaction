/*
===============================================================================
View: vw_earnings_event_window
===============================================================================
Purpose:
    - Builds the event window around each earnings announcement.
    - Includes trading days from -3 to +3 relative to the earnings trading day
      (where event_day = 0 is the first trading day on or after announcement).
    - Provides price_date, close_price, and calculated event_day for analysis.

Dependencies:
    - vw_stock_trading_calendar (columns: company_id, price_date, close_price,
      trading_day_index)
    - vw_earnings_trading_day (columns: company_id, earnings_date,
      earnings_trading_index)
    - dim_company (columns: company_id, symbol)

Functions Used:
    - Multi-table JOIN
    - Arithmetic in SELECT (trading_day_index - earnings_trading_index)
    - WHERE with BETWEEN for event window filtering
===============================================================================
*/

CREATE VIEW vw_earnings_event_window AS
SELECT
    c.company_id,
    d.symbol,
    e.earnings_date,
    c.price_date,
    c.close_price,
    c.trading_day_index - e.earnings_trading_index AS event_day
FROM vw_stock_trading_calendar c
JOIN vw_earnings_trading_day e
    ON c.company_id = e.company_id
JOIN dim_company d
    ON c.company_id = d.company_id
WHERE c.trading_day_index BETWEEN
      e.earnings_trading_index - 3
  AND e.earnings_trading_index + 3;

