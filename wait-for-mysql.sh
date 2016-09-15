echo "Wait for mysql to start up"
MYSQL_HOSTNAME=db
MYSQL_PORT=3306
until nc -z -v -w30 $MYSQL_HOSTNAME $MYSQL_PORT; do
    echo "."
    sleep 2
done
