# Distributed Hotel Rating & Booking Platform

[![Spring Boot](https://img.shields.io/badge/Spring_Boot-2.7-green?style=for-the-badge&logo=springboot)](https://spring.io/projects/spring-boot)
[![Spring Cloud](https://img.shields.io/badge/Spring_Cloud-2021.0.5-blue?style=for-the-badge&logo=spring)](https://spring.io/projects/spring-cloud)
[![Resilience4j](https://img.shields.io/badge/Resilience4j-Resilient-orange?style=for-the-badge)](https://resilience4j.readme.io/)
[![Docker](https://img.shields.io/badge/Docker-Enabled-blue?style=for-the-badge&logo=docker)](https://www.docker.com/)

A modern, highly resilient, and fault-tolerant microservices-based application built with **Spring Boot** and **Spring Cloud**. This system demonstrates dynamic service discovery, centralized configuration, API routing, and robust fault-tolerance mechanisms.

---

## 🏛️ System Architecture

The application is structured into specialized services that communicate over a distributed network:

```mermaid
graph TD
    subgraph Databases
        mysql[(MySQL:3307)]
        postgres[(Postgres:5432)]
        mongo[(MongoDB:27017)]
    end

    subgraph Service Registry & Config
        eureka[Eureka Registry:8761]
        config[Config Server:8085]
    end

    subgraph Gateway & Core API
        gateway[API Gateway:8084]
        user[User Service:8081]
        hotel[Hotel Service:8082]
        rating[Rating Service:8083]
    end

    %% Database Connections
    user --> mysql
    hotel --> postgres
    rating --> mongo
    
    %% Communication & Registrations
    user --> eureka
    hotel --> eureka
    rating --> eureka
    gateway --> eureka
    
    config --> eureka
    user --> config
    hotel --> config
    gateway --> config
```

---

## ⚙️ Tech Stack & Microservices Overview

### Infrastructure Services
*   **API Gateway (8084)**: Acts as the single entry point. Integrates **Okta OAuth2** for request validation and security token checks. Dynamically routes requests using service names (`lb://`).
*   **Service Registry (8761)**: Powered by **Netflix Eureka Server** for dynamic service registration and lookup.
*   **Config Server (8085)**: Centralized configuration manager fetching service settings from a remote Git repository.

### Core Business Services
*   **User Service (8081)**: Manages users and orchestrates rating details. Connects to **MySQL**. Uses **Resilience4j** annotations for Circuit Breaker, Retry, and Rate Limiter.
*   **Hotel Service (8082)**: Manages hotels. Connects to **PostgreSQL**.
*   **Rating Service (8083)**: Manages rating reviews. Connects to **MongoDB**.

---

## ⚡ Resilience & Fault Tolerance (Resilience4j)

The `UserService` controller handles transient network issues and cascading microservices failures gracefully:
*   **Circuit Breaker (`ratingHotelBreaker`)**: Prevents continuous requests to down services. Falls back to a default mock user response.
*   **Rate Limiter (`userRateLimiter`)**: Limits user requests (e.g., 2 calls per 4 seconds) to prevent brute force/server overloading.
*   **Retry (`ratingHotelService`)**: Automatically retries failed service calls 3 times before triggering fallback mechanisms.

---

## 🚀 One-Click Launch in GitHub Codespaces (Free Cloud Hosting)

This repository is equipped with a Dev Container setup allowing you to run the complete ecosystem in a free 8GB cloud machine:

1. Click on the green **Code** button at the top of the repository.
2. Select **Codespaces** and click **Create codespace on main**.
3. Once the environment loads, it will automatically:
   - Run Docker and Docker Compose.
   - Boot up the databases and all microservices.
   - Expose public URLs for the API Gateway and Eureka Registry in the **Ports** panel.

---

## 🐳 Running Locally (Docker Compose)

### Prerequisites
*   Docker Desktop installed.

### Commands
In the root directory of the project, run:
```bash
docker-compose up -d --build
```
This builds all microservices images and boots up the entire suite. You can monitor the startup using:
```bash
docker-compose logs -f
```

### Exposed Endpoints
*   **Eureka Dashboard**: `http://localhost:8761`
*   **Config Server**: `http://localhost:8085`
*   **API Gateway Route (Users)**: `http://localhost:8084/users`
