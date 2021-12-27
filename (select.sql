SELECT
  *
FROM
  (
    select
      *
    from
      (
        SELECT
          APP,
          task_name,
          TASK_ID,
          COST,
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
              APP,
              task_name,
              TASK_ID,
              COST,
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
      and APP = 'PDC'
      and begin_time BETWEEN to_date(
        to_char(SYSDATE - 7, 'yyyy/MM/dd'),
        'yyyy/MM/dd'
      )
      AND to_date(to_char(SYSDATE, 'yyyy/MM/dd'), 'yyyy/MM/dd')
    order by
      task_id
  ) t1 pivot (
    sum(t1.cost) FOR task_name IN ('生成个人账户基本信息文件并上传','生成个人基本信息文件并上传','生成个人账户月度表现文件并上传','生成个人相关还款责任人信息文件并上传')
  )