select
  *
from
  (
    SELECT
      task_name,
      TASK_ID,
      BEGIN_TIME,
      begin_date,
      ROW_NUMBER() OVER(
        PARTITION BY TASK_ID,
        begin_date
        ORDER BY
          BEGIN_TIME desc
      ) AS RN
    FROM
      (
        SELECT
          task_name,
          TASK_ID,
          BEGIN_TIME,
          TO_CHAR(BEGIN_TIME, 'YYYYMMDD') AS BEGIN_DATE
        FROM
          SSM_TASK_MONITOR_INFO
        where
          BEGIN_TIME IS not NULL
      ) T
  )
where
  rn = 1
order by
  task_id;