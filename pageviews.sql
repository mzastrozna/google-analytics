SELECT
  COUNT(*) AS views
FROM
    `project.dataset.events_*` --replace with your own project name and dataset name
WHERE
  _TABLE_SUFFIX BETWEEN '20231001' AND '20231031' --replace with dates needed (YYYYMMDD)
  AND event_name = 'page_view'
