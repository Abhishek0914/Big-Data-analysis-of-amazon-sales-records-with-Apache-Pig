sales_data = LOAD '/Users/abhishekbohra/Documents/AmazonSalesData_analysis/Amazon_Sale_Report.csv' USING PigStorage(',') 
    AS (index:int, order_id:chararray, date:chararray, status:chararray, 
        fulfilment:chararray, sales_channel:chararray, 
        ship_service_level:chararray, style:chararray, sku:chararray, 
        category:chararray, size:chararray, asin:chararray, 
        courier_status:chararray, qty:int, currency:chararray, 
        amount:double, ship_city:chararray, ship_state:chararray, 
        ship_postal_code:chararray, ship_country:chararray, 
        promotion_ids:chararray, b2b:boolean, fulfilled_by:chararray);

clean_data = FILTER sales_data BY amount IS NOT NULL AND amount > 0 AND 
             status != 'Cancelled';

STORE clean_data INTO '/Users/abhishekbohra/Documents/AmazonSalesData_analysis/output' USING PigStorage(',');