SELECT
  collected_traffic_source.manual_source AS utm_source,
  collected_traffic_source.manual_medium AS utm_medium,
  collected_traffic_source.manual_campaign_name AS utm_campaign,
  COUNT(DISTINCT CONCAT(event_params2.value.int_value, user_pseudo_id)) AS sessions
FROM
  `project.dataset.events_*` --replace with your own project name and dataset name
LEFT JOIN
  UNNEST(t.event_params) AS event_params
LEFT JOIN
  UNNEST(t.event_params) AS event_params2 --i need a second UNNEST to be able to filter by key = "ga_session_id"
WHERE
  _TABLE_SUFFIX BETWEEN '20231001' AND '20231031' --replace with dates needed (YYYYMMDD)
  AND event_params.key = "entrances"
  AND event_params2.key = "ga_session_id"
  AND event_name = "page_view"
  AND event_params.value.int_value = 1
GROUP BY 1,2,3
