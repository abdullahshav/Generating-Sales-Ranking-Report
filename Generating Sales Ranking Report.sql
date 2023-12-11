SELECT
    c.customer_id,
    c.customer_name,
    s.sales_channel,
    ROUND(SUM(s.total_sales), 2) AS total_sales
FROM
    customers c
JOIN
    sales s ON c.customer_id = s.customer_id
WHERE
    c.customer_id IN (
        SELECT
            customer_id
        FROM
            (
                SELECT
                    customer_id,
                    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY total_sales DESC) AS sales_rank
                FROM
                    sales
                WHERE
                    sales_year IN (1998, 1999, 2001)
            ) ranked_sales
        WHERE
            sales_rank <= 300
    )
GROUP BY
    c.customer_id, c.customer_name, s.sales_channel
ORDER BY
    s.sales_channel, total_sales DESC;