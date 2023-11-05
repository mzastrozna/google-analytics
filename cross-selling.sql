WITH

--purchased items
items AS (
  SELECT DISTINCT
    ecommerce.transaction_id AS transaction_id,
    items.item_id AS item_id
  FROM
    `project.dataset.events_*` --replace with your own project name and dataset name
  LEFT JOIN
    UNNEST(items) AS items
  WHERE
    _TABLE_SUFFIX BETWEEN '20231001' AND '20231031' --replace with dates needed (YYYYMMDD)
    AND event_name = 'purchase'
    AND ecommerce.unique_items > 1
),

--we need a matrix with two dimensions (item_id_1 and item_id_2), so I'm creating two tables (CTEs)
items_1 AS (
  SELECT DISTINCT
    transaction_id,
    item_id AS item_id_1
  FROM
    items
),

items_2 AS (
  SELECT DISTINCT
    transaction_id,
    item_id AS item_id_2
  FROM
    items
),

-- pairs of items purchased together matched by transaction_id
baskets AS (
  SELECT
    transaction_id,
    (SELECT
      STRING_AGG(el, ', ' ORDER BY el)
    FROM
      UNNEST(array[item_id_1, item_id_2]) el
    ) AS basket
  FROM
  (SELECT
    item_id_1,
    item_id_2,
    transaction_id
  FROM
    items_1
  LEFT JOIN
    items_2 USING(transaction_id)
  WHERE
    item_id_1 != item_id_2)
)

SELECT
  basket,
  COUNT(DISTINCT transaction_id) AS transactions
FROM
  baskets
GROUP BY 1
ORDER BY 2 DESC
