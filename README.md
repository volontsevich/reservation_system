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

#### First run

```bash
docker compose build
docker compose run web --rm rails db:create
docker compose run web --rm rails db:migrate
docker compose run web --rm rails db:seed

docker compose up
```

These commands build the Docker image for the application, start the services defined in the docker-compose.yml file and
preparing the DB and dummy data.

#### Everyday usage

```bash
docker compose up
docker compose stop
```

#### Debugging the application

```bash
docker compose run --rm web rails c`
```

### API Endpoints

#### List Restaurants:

- **GET** `http://localhost:3000/api/v2/restaurants`

**Example Request:**

```bash
curl -X GET http://localhost:3000/api/v2/restaurants
```

**Example Response:**

```json
[
  {
    "id": 1,
    "name": "The Gourmet Kitchen"
  },
  {
    "id": 2,
    "name": "Cafe Delight"
  }
]
```

#### Create Reservation:

- **POST** `http://localhost:3000/api/v2/restaurants/:restaurant_id/reservations`

**Example Request:**

```bash
curl -X POST http://localhost:3000/api/v2/restaurants/1/reservations \
     -H "Content-Type: application/json" \
     -d '{"party_size": 4, "start_time": "2024-03-20T19:00:00Z", "duration": 3600}'
```

**Example Response:**

```json
{
  "id": 1,
  "restaurant_id": 1,
  "table_id": 5,
  "party_size": 4,
  "start_time": "2024-03-20T19:00:00Z",
  "end_time": "2024-03-20T20:00:00Z"
}
```

#### List Occupied Tables:

- **GET** `http://localhost:3000/api/v2/restaurants/:restaurant_id/tables/occupied?time=2024-03-11T16:28:08.000Z`

**Example Request:**

```bash
curl -X GET "http://localhost:3000/api/v2/restaurants/1/tables/occupied?time=2024-03-11T16:28:08.000Z"
```

**Example Response:**

```json
[
  {
    "table_id": 5,
    "table_number": 10,
    "seats_amount": 4,
    "reservations": [
      {
        "reservation_id": 1,
        "start_time": "2024-03-11T15:00:00Z",
        "end_time": "2024-03-11T17:00:00Z",
        "party_size": 4
      }
    ]
  }
]
```

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

docker compose run --rm web rspec './spec/requests/api/v2/reservations_spec.rb'
```

### Versions and assignment strategies

#### V1

**Simple assignment logic**: This version implements a straightforward check to ensure at least one table is available
without reservations for the requested start time and duration. It selects the table with the smallest number of seats
that can accommodate the party size.

#### V2

**Enhanced Assignment Logic**: Building on V1, this version adjusts the reservation's start time to align with the
restaurant's opening hours and searches for any available time slot before the restaurant closes. The start time of the
reservation may be adjusted to find an available table if none are free for the initially requested time and duration.

#### V3

**To Be Determined**: Potential enhancements to the V2 logic include:

- **Combining Tables for Larger Parties**: An approach to assemble a set of smaller, free tables to accommodate large
  parties as soon as possible, rather than waiting for a larger table to become available. This method, however, would
  require significant changes to the database and model relationships, rendering V1 and V2 obsolete and requiring
  substantial development effort to maintain compatibility.
- **Queue Logic for Reservation Requests**: Introducing a queue system to manage reservation requests with some delay,
  allowing for more efficient utilization of table seating capacity. This system would require integrating a queue
  service (e.g., RabbitMQ) and creation of the frontend application with WebSockets for receiving delayed reservation
  notifications. 