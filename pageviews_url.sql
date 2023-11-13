SELECT
  event_params.value.string_value AS page_url,
  COUNT(*) AS pageviews
FROM
  `project.dataset.events_*` --replace with your own project name and dataset name AS t
LEFT JOIN
  UNNEST(t.event_params) AS event_params
WHERE
  _TABLE_SUFFIX BETWEEN '20211201' AND '20211231'
  AND event_params.key = "page_location"
  AND event_name = "page_view"
GROUP BY page_url
ORDER BY pageviews DESC
