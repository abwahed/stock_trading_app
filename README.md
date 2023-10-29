# StockTradingApp

Welcome to StockTradingApp!

## Table of Contents

- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Configuration](#configuration)
    - [Authentication](#authentication)
- [Usage](#usage)
  - [Business API](#business-api)
  - [Order API](#order-api)

## Getting Started

### Prerequisites

Before you begin, ensure you have the following prerequisites installed:

- Ruby 3.2.2
- Rails 7.0.8

### Installation

1. Clone the repository: `git clone git@github.com:abwahed/stock_trading_app.git`
2. Navigate to the project directory: `cd stock_trading_app`
3. Install gem dependencies: `bundle install`
4. Set up the database: `rails db:setup`
5. Run DB migrate: `rails db:migrate`
6. Start the Rails server: `rails server`

### Configuration

Open `config/database.yml` file and set the password for your development mysql database.

### Authentication

This app uses HTTP basic authentication with `username` and `password`

## Usage

### Business API
- **create**

  *end_point*: POST `base_url/businesses`

  *request body*
  ```json
  {
    "business" : {
        "name" : "XYZ Inc.",
        "shares_available": 400
    }
  }
  ```
  
- **index**

  *end_point*: GET `base_url/businesses`


- **order_history**

  *end_point*: GET `base_url/businesses/:id/order_history`


### Order API
- **create**

  *end_point*: POST `base_url/businesses/:business_id/orders`

  *request body*
  ```json
  {
    "order" : {
        "quantity" : 12,
        "price": 40.55
    }
  }
  ```
- **index**

  *end_point*: GET `base_url/businesses/:business_id/orders`


- **update**

  *end_point*: PATCH `base_url/orders/:id`

  *request body*
  ```json
  {
    "order" : {
        "quantity" : 12,
        "price": 40.55
    }
  }
  ```

- **accept**

  *end_point*: PATCH `base_url/orders/:id/accept`


- **reject**

  *end_point*: PATCH `base_url/orders/:id/reject`

