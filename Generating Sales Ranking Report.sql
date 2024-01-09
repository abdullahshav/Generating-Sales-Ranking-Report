WITH RankedCustomers AS (
 SELECT cust_id, cust_first_name, cust_last_name, channel_desc, calendar_year,
	    ROUND(SUM(amount_sold), 2) AS total_sales,
        RANK() OVER (PARTITION BY calendar_year, channel_desc ORDER BY SUM(amount_sold) DESC) AS sales_rank
 FROM sh.customers cust
 JOIN sh.sales s USING(cust_id)
 JOIN sh.channels ch USING(channel_id)
 JOIN sh.times t USING(time_id)
 WHERE t.calendar_year IN (1998, 1999, 2001)
 GROUP BY cust_id, channel_desc, calendar_year
)
SELECT cust_id, cust_first_name, cust_last_name, channel_desc, calendar_year, total_sales, sales_rank 
FROM RankedCustomers
WHERE sales_rank <= 300;
