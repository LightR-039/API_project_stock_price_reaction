CREATE TABLE dim_company (
    company_id INT IDENTITY(1,1) PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL UNIQUE,
    company_name VARCHAR(100)
);

CREATE TABLE fact_earnings (
    earnings_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    earnings_date DATE NOT NULL,
    revenue BIGINT,
    eps DECIMAL(10,4),
    gross_profit BIGINT,
    operating_income BIGINT,
    net_income BIGINT,

    CONSTRAINT fk_earnings_company
        FOREIGN KEY (company_id)
        REFERENCES dim_company(company_id),

    CONSTRAINT uq_earnings
        UNIQUE (company_id, earnings_date)
);

SELECT * FROM fact_earnings

CREATE TABLE fact_stock_prices (
    price_id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL,
    price_date DATE NOT NULL,
    open_price DECIMAL(18,4),
    high_price DECIMAL(18,4),
    low_price DECIMAL(18,4),
    close_price DECIMAL(18,4),
    volume BIGINT,
    vwap DECIMAL(18,4),

    CONSTRAINT fk_prices_company
        FOREIGN KEY (company_id)
        REFERENCES dim_company(company_id),

    CONSTRAINT uq_stock_price
        UNIQUE (company_id, price_date)
);

SELECT * FROM fact_stock_prices

CREATE TABLE fact_market_index (
    market_id INT IDENTITY(1,1) PRIMARY KEY,
    index_symbol VARCHAR(10) NOT NULL,
    price_date DATE NOT NULL,
    open_price DECIMAL(18,4),
    high_price DECIMAL(18,4),
    low_price DECIMAL(18,4),
    close_price DECIMAL(18,4),
    volume BIGINT,
    vwap DECIMAL(18,4),

    CONSTRAINT uq_market_price
        UNIQUE (index_symbol, price_date)
);


SELECT * FROM fact_market_index