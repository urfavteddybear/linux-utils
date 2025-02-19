!/bin/bash

# List of services to start/stop (excluding PHP modules which don't have systemd services)
services=("php8.2-fpm" "nginx" "mariadb")

# Function to start the services
start_services() {
    for service in "${services[@]}"
    do
        echo "Starting service: $service"
        sudo systemctl start $service
    done

    echo "All specified services have been started."
}

# Function to stop the services
stop_services() {
    for service in "${services[@]}"
    do
        echo "Stopping service: $service"
        sudo systemctl stop $service
    done

    echo "All specified services have been stopped."
}

# Check the parameter passed to the script (start or stop)
if [ "$1" == "start" ]; then
    start_services
elif [ "$1" == "stop" ]; then
    stop_services
else
    echo "Usage: $0 {start|stop}"
    exit 1
fi