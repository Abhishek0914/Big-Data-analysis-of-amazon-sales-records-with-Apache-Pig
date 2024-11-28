-- Load the cleaned data
clean_data = LOAD '/Users/abhishekbohra/Documents/AmazonSalesData_analysis/output' USING PigStorage(',') 
    AS (index:int, order_id:chararray, date:chararray, status:chararray, 
        fulfilment:chararray, sales_channel:chararray, 
        ship_service_level:chararray, style:chararray, sku:chararray, 
        category:chararray, size:chararray, asin:chararray, 
        courier_status:chararray, qty:int, currency:chararray, 
        amount:double, ship_city:chararray, ship_state:chararray, 
        ship_postal_code:chararray, ship_country:chararray, 
        promotion_ids:chararray, b2b:boolean, fulfilled_by:chararray);

-----------------------------------------------------------
-- Objective 1: Top-Selling Products (by Quantity)
-----------------------------------------------------------
group_by_sku = GROUP clean_data BY sku;
product_sales = FOREACH group_by_sku GENERATE 
    group AS sku, 
    SUM(clean_data.qty) AS total_quantity, 
    SUM(clean_data.amount) AS total_revenue;
top_products = ORDER product_sales BY total_quantity DESC;
STORE top_products INTO '/Users/abhishekbohra/Documents/AmazonSalesData_analysis/output1' USING PigStorage(',');

-----------------------------------------------------------
-- Objective 2: Revenue by Region (State-Wise)
-----------------------------------------------------------
group_by_state = GROUP clean_data BY ship_state;
state_revenue = FOREACH group_by_state GENERATE 
    group AS state, 
    SUM(clean_data.amount) AS total_revenue;
sorted_state_revenue = ORDER state_revenue BY total_revenue DESC;
STORE sorted_state_revenue INTO '/Users/abhishekbohra/Documents/AmazonSalesData_analysis/output2' USING PigStorage(',');

-----------------------------------------------------------
-- Objective 3: Monthly Revenue Trends
-----------------------------------------------------------
with_month = FOREACH clean_data GENERATE *, 
    SUBSTRING(date, 0, 7) AS month_year;
group_by_month = GROUP with_month BY month_year;
monthly_revenue = FOREACH group_by_month GENERATE 
    group AS month_year, 
    SUM(with_month.amount) AS total_revenue;
sorted_monthly_revenue = ORDER monthly_revenue BY month_year;
STORE sorted_monthly_revenue INTO '/Users/abhishekbohra/Documents/AmazonSalesData_analysis/output3' USING PigStorage(',');

-----------------------------------------------------------
-- Objective 4: Fulfillment Performance
-----------------------------------------------------------
group_by_fulfillment = GROUP clean_data BY fulfilment;
fulfillment_revenue = FOREACH group_by_fulfillment GENERATE 
    group AS fulfillment_type, 
    SUM(clean_data.amount) AS total_revenue, 
    COUNT(clean_data.order_id) AS total_orders;
STORE fulfillment_revenue INTO '/Users/abhishekbohra/Documents/AmazonSalesData_analysis/output4' USING PigStorage(',');

-----------------------------------------------------------
-- Objective 5: Order Status Breakdown
-----------------------------------------------------------
group_by_status = GROUP clean_data BY status;
status_count = FOREACH group_by_status GENERATE 
    group AS order_status, 
    COUNT(clean_data.order_id) AS total_orders;
STORE status_count INTO '/Users/abhishekbohra/Documents/AmazonSalesData_analysis/output5' USING PigStorage(',');

-----------------------------------------------------------
-- Objective 6: Revenue by Product Category
-----------------------------------------------------------
group_by_category = GROUP clean_data BY category;
category_revenue = FOREACH group_by_category GENERATE 
    group AS category, 
    SUM(clean_data.amount) AS total_revenue;
sorted_category_revenue = ORDER category_revenue BY total_revenue DESC;
STORE sorted_category_revenue INTO '/Users/abhishekbohra/Documents/AmazonSalesData_analysis/output6' USING PigStorage(',');

-----------------------------------------------------------
-- Objective 7: Top Customers (Based on Revenue)
-----------------------------------------------------------
group_by_customer = GROUP clean_data BY order_id;
customer_revenue = FOREACH group_by_customer GENERATE 
    group AS customer_id, 
    SUM(clean_data.amount) AS total_revenue, 
    COUNT(clean_data.order_id) AS total_orders;
sorted_customer_revenue = ORDER customer_revenue BY total_revenue DESC;
STORE sorted_customer_revenue INTO '/Users/abhishekbohra/Documents/AmazonSalesData_analysis/output7' USING PigStorage(',');