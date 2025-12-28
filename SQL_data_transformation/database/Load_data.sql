INSERT INTO dim_company (symbol, company_name)
SELECT DISTINCT
    symbol,
    CASE symbol
        WHEN 'AMZN' THEN 'Amazon'
        WHEN 'GOOGL' THEN 'Alphabet'
    END AS company_name
FROM stage_earnings;

SELECT * FROM dim_company

INSERT INTO fact_earnings (
    company_id,
    earnings_date,
    revenue,
    eps,
    gross_profit,
    operating_income,
    net_income
)
SELECT
    c.company_id,
    CAST(s.date AS DATE) AS earnings_date,
    s.revenue,
    s.eps,
    s.grossProfit,
    s.operatingIncome,
    s.netIncome
FROM stage_earnings s
JOIN dim_company c
    ON s.symbol = c.symbol;

SELECT * FROM fact_earnings;

INSERT INTO fact_stock_prices (
    company_id,
    price_date,
    open_price,
    high_price,
    low_price,
    close_price,
    volume,
    vwap
)
SELECT
    c.company_id,
    CAST(s.date AS DATE) AS price_date,
    s.[open],
    s.high,
    s.low,
    s.[close],
    s.volume,
    s.vwap
FROM stage_stock_prices s
JOIN dim_company c
    ON s.symbol = c.symbol;

SELECT * FROM fact_stock_prices;

INSERT INTO fact_market_index (
    index_symbol,
    price_date,
    open_price,
    high_price,
    low_price,
    close_price,
    volume,
    vwap
)
SELECT
    index_symbol,
    CAST(date AS DATE) AS price_date,
    [open],
    high,
    low,
    [close],
    volume,
    vwap
FROM stage_market_index;

SELECT * FROM fact_market_index;

SELECT *
FROM fact_earnings e
LEFT JOIN dim_company c
    ON e.company_id = c.company_id
WHERE c.company_id IS NULL;

SELECT company_id, earnings_date, COUNT(*)
FROM fact_earnings
GROUP BY company_id, earnings_date
HAVING COUNT(*) > 1;

SELECT
    c.symbol,
    COUNT(DISTINCT e.earnings_date) AS earnings_count,
    COUNT(DISTINCT p.price_date) AS price_days
FROM dim_company c
LEFT JOIN fact_earnings e ON c.company_id = e.company_id
LEFT JOIN fact_stock_prices p ON c.company_id = p.company_id
GROUP BY c.symbol;


