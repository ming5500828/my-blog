SELECT
  BEGIN_DATE,
  SUM(NVL(C1, 0)) C1,
  SUM(NVL(C2, 0)) C2,
  SUM(NVL(C3, 0)) C3
FROM
  (
    SELECT
      *
    FROM
      (
        SELECT
          APP,
          TASK_NAME,
          TASK_ID,
          COST,
          BEGIN_TIME,
          BEGIN_DATE
        FROM
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
                  BEGIN_TIME DESC
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
                WHERE
                  BEGIN_TIME IS NOT NULL
              ) T
          ) T1
        WHERE
          rn = 1
          AND APP = 'EPAY'
          AND begin_time BETWEEN to_date(
            TO_CHAR(SYSDATE - 7, 'yyyy/MM/dd'),
            'yyyy/MM/dd'
          )
          AND TO_DATE(TO_CHAR(SYSDATE, 'yyyy/MM/dd'), 'yyyy/MM/dd')
      ) T2 PIVOT (
        SUM(T2.COST) FOR TASK_NAME IN (
          'ReconFileJobHandler' C1,
          'SettleJobHandler' C2,
          'coreReconciliationTask' C3
        )
      )
  )
GROUP BY
  begin_date