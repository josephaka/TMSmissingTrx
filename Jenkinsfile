withEnv([
    'UserAgentString="okhttp"']) {
    Microservice(
        name: 'acquiring-daily-settlement-data-service',
        type: 'dbt',
        namespace: 'data',
        serviceTesting: false,
        cronJob: true,
        production: true,
        deployPR: false,
        commonFlags: "--set \"tolerations[0].key=dbt\" \
        --set \"tolerations[0].operator=Exists\" \
        --set \"tolerations[0].effect=NoSchedule\" \
        --set nodeSelector.purpose=dbt \
        --set activeDeadlineSeconds=18000",
        qaFlags: "--set config.ENV=qa \
            --set config.START_DAY=7 \
            --set config.DAILY_SETTLEMENT_AM_CUT_OFF_HOUR=00:00:00 \
            --set config.DAILY_SETTLEMENT_PM_CUT_OFF_HOUR=00:00:00 \
            --set config.DATAWAREHOUSE_DB_NAME=card_acquiring \
            --set schedule='05\\,10\\,00 2 * * 1-5'",
        prodFlags: "--set config.ENV=prod \
            --set config.START_DAY=7 \
            --set config.DAILY_SETTLEMENT_AM_CUT_OFF_HOUR=00:00:00 \
            --set config.DAILY_SETTLEMENT_PM_CUT_OFF_HOUR=00:00:00 \
            --set config.DATAWAREHOUSE_DB_NAME=card_acquiring_settlement \
            --set schedule='05\\,10\\,00 1 * * 1-5'",
        dbtVersion: "0.19.1"
    )
}



