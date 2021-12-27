SELECT
  *
FROM
  (
    SELECT
      *
    FROM
      (
        SELECT
          to_char(begin_time, 'yyyy-MM-dd') AS begin_time,
          cost,
          task_name
        FROM
          SSM_TASK_MONITOR_INFO
        WHERE
          APP = 'PDC'
          AND begin_time BETWEEN to_date(
            to_char(SYSDATE - 7, 'yyyy/MM/dd'),
            'yyyy/MM/dd'
          )
          AND to_date(to_char(SYSDATE, 'yyyy/MM/dd'), 'yyyy/MM/dd')
      ) t1 pivot (
        sum(t1.cost) FOR task_name IN ('settleJobHandler', 'settleJobHandler1')
      )
  ) t
ORDER BY
  t.begin_time


  select
  SUM(
    case
      when t.TASK_NAME
      when '生成个人账户基本信息文件并上传' then t.COST
      else 0
    ) as '生成个人账户基本信息文件并上传',
    SUM(
      case
        when t.TASK_NAME
        when '生成个人基本信息文件并上传' then t.COST
        else 0
      ) as '生成个人基本信息文件并上传',
      SUM(
        case
          when t.TASK_NAME
          when '生成个人账户月度表现文件并上传' then t.COST
          else 0
        ) as '生成个人账户月度表现文件并上传',
        from
          t  group by t.BEGIN_DATE