#!/bin/bash
echo "================================================================="
echo "Building all microservices using local maven cache..."
echo "================================================================="

# Set exit on error
set -e

services=(
  "ServiceRegistry/ServiceRegistry"
  "ConfigServer/ConfigServer"
  "ApiGateway/ApiGateway"
  "HotelService/HotelService"
  "RatingService/RatingService"
  "UserService/UserService"
)

# Remember root directory
ROOT_DIR=$(pwd)

for service in "${services[@]}"; do
  echo "-----------------------------------------------------------------"
  echo "Building: $service"
  echo "-----------------------------------------------------------------"
  cd "$ROOT_DIR/$service"
  chmod +x mvnw
  ./mvnw clean package -DskipTests
done

cd "$ROOT_DIR"
echo "================================================================="
echo "All microservices compiled successfully!"
echo "================================================================="
