
if [ "$INFLUXDB_START" = "true" ]
then
    influxd --http-bind-address :8086 --reporting-disabled > /dev/null 2>&1 &
    until curl -s http://localhost:8086/health; do sleep 1; done
    influx setup --host http://localhost:8086 -f \
        -o $INFLUXDB_ORG \
        -u $INFLUXDB_USER \
        -p $INFLUXDB_PASSWORD \
        -b $INFLUXDB_BUCKET
    influx auth create --user $INFLUXDB_USER --org $INFLUXDB_BUCKET --read-buckets --write-buckets
    export INFLUXDB_TOKEN=$(influx auth list | grep $INFLUXDB_USER | grep -o "[[:alnum:]\_\-]*==")
fi
