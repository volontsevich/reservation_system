# Restaurant Reservation System

## System Design and Architectural Choices

The Restaurant Reservation System is designed to facilitate online reservations for restaurants, efficiently managing
table allocations to maximize occupancy and customer satisfaction. RESTful API built on Ruby on Rails.

### Core Entities

- **Restaurant**: Represents a restaurant entity, containing details like name.
- **Table**: Associated with a restaurant, detailing table numbers and seating capacity.
- **Reservation**: Manages reservation details, including party size, reservation start, and end times.

### Architectural Overview

The application follows a service-oriented architecture (SOA), with a clear separation between the web interface (API
endpoints) and the business logic (services). This separation allows for modular development and testing, making the
system adaptable to future requirements.

## Setup and Run Instructions

### Prerequisites

- Docker
- Docker Compose

### Getting Started

1. **Clone the repository:**

```bash
git clone https://github.com/volontsevich/reservation_system.git
cd reservation_system
```

2. **Build and run the application using Docker Compose:**

```bash
docker compose build
docker compose run web --rm rails db:create
docker compose run web --rm rails db:migrate
docker compose run web --rm rails db:seed
docker compose up

```

This command builds the Docker image for the application and starts the services defined in the docker-compose.yml file.

### API Endpoints

- List Restaurants: `GET http://localhost:3000/restaurants`
- Create Reservation: `POST http://localhost:3000/restaurants/:restaurant_id/reservations`
    - Body: { "party_size": 4, "start_time": "2024-03-20T19:00:00Z", "duration": 3600 }
- List Occupied Tables: `GET http://localhost:3000/restaurants/:restaurant_id/tables/occupied?time=2024-03-11T16:28:08.000Z`

### Testing Approach

The application employs RSpec for testing, focusing on model validations, controller actions, and key functionalities
such as table allocation logic. Test cases include:

- Reservation Creation: Validates successful reservation creation and error handling for invalid requests.
- Table Allocation: Tests ensure that tables are allocated correctly based on party size and reservation time, including
  scenarios with overlapping reservations.

### Running Tests

Execute the following command to run the test suite:

```
docker compose run --rm web rspec
```