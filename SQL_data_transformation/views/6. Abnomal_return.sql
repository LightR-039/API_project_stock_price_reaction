/*
===============================================================================
View: vw_abnormal_returns
===============================================================================
Purpose:
    - Calculates abnormal returns during the earnings event window (±3 days).
    - Abnormal return = stock daily return - market daily return (NASDAQ ^IXIC).
    - Provides the core data needed for event study analysis around earnings.

Dependencies:
    - vw_earnings_event_window (columns: company_id, symbol, earnings_date,
      price_date, event_day)
    - vw_stock_daily_returns (columns: company_id, price_date, stock_return)
    - vw_market_daily_returns (columns: price_date, market_return, index_symbol)

Functions Used:
    - Multi-table JOIN on company_id/price_date and market index/date
    - Simple arithmetic subtraction for abnormal_return
===============================================================================
*/

CREATE OR ALTER VIEW vw_abnormal_returns AS
SELECT
    ew.company_id,
    ew.symbol,
    ew.earnings_date,
    ew.price_date,
    ew.event_day,
    s.stock_return,
    m.market_return,
    (s.stock_return - m.market_return) AS abnormal_return
FROM vw_earnings_event_window ew
JOIN vw_stock_daily_returns s
    ON ew.company_id = s.company_id
   AND ew.price_date = s.price_date
JOIN vw_market_daily_returns m
    ON ew.price_date = m.price_date
   AND m.index_symbol = '^IXIC';
