# Market Money
![Tests](https://badgen.net/badge/tests/passing/green?icon=github)
![Commits](https://badgen.net/github/last-commit/DavisWeimer/market_money?icon=github)
![Issues](https://badgen.net/github/closed-issues/DavisWeimer/market_money?icon=github)
[![Maintainability](https://api.codeclimate.com/v1/badges/c30f96f199f34a08cf7e/maintainability)](https://codeclimate.com/github/DavisWeimer/market_money/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/c30f96f199f34a08cf7e/test_coverage)](https://codeclimate.com/github/DavisWeimer/market_money/test_coverage)

Market Money is an API built from scratch utilizing a `pgdump` to seed the development database. It is also consuming the TomTom API to locate nearby ATM's by lat/lon coordinates.

## Ruby/Rails version<br>
`Ruby 3.2.2`<br>
`Rails 7.0.7.2`

## Built with<br>
![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)
![Postgresql](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)
![Postman Badge](https://img.shields.io/badge/Postman-FF6C37?logo=postman&logoColor=fff&style=for-the-badge)

Getting Started
-------------
To get a local copy, follow these steps

### <b>Installation</b>

1. Fork the Project
2. Clone the repo (SSH) 
```shell 
git@github.com:DavisWeimer/market_money.git 
```
3. Install the gems
```ruby
bundle install
```
4. Create the database
```ruby
rails db:{drop,create,migrate,seed}
```
**NOTE:** *You may see lots of output including some warnings/errors from pg_restore you can ignore.*

5. Add schema
```ruby
rails db:schema:dump
```
6. Check db in the Rails Console
```ruby
rails c 
```
```ruby
Market.all.first
```

You should see:

```ruby
<Market id: 322458, name: "14&U Farmers' Market", street: "1400 U Street NW ", city: "Washington", county: "District of Columbia", state: "District of Columbia", zip: "20009", lat: "38.9169984", lon: "-77.0320505">
```

### <b>Endpoints Available</b>
1. Get All Markets
```ruby
GET /api/v0/markets
```
2. Get One Market
```ruby
GET /api/v0/markets/:id
```
3. Get All Vendors for a Market
```ruby
GET /api/v0/markets/:id/vendors
```
4. Get One Vendor
```ruby
GET /api/v0/vendors/:id
```
5. Create a Vendor
```ruby
POST /api/v0/vendors
```
6. Update a Vendor
```ruby
PATCH /api/v0/vendors/:id
```
7. Delete a Vendor
```ruby
DELETE /api/v0/vendors/:id
```
8. Create a MarketVendor
```ruby
POST /api/v0/market_vendors
```
9. Delete a MarketVendor
```ruby
DELETE /api/v0/market_vendors
```
10. Search Markets by state, city, and/or name
```ruby
GET /api/v0/markets/search
```
11. Get Cash Dispenser Near a Market
```ruby
GET /api/v0/markets/:id/nearest_atms
```


## Schema
```ruby
  create_table "market_vendors", force: :cascade do |t|
    t.bigint "market_id"
    t.bigint "vendor_id"
    t.index ["market_id"], name: "index_market_vendors_on_market_id"
    t.index ["vendor_id"], name: "index_market_vendors_on_vendor_id"
  end

  create_table "markets", force: :cascade do |t|
    t.string "name"
    t.string "street"
    t.string "city"
    t.string "county"
    t.string "state"
    t.string "zip"
    t.string "lat"
    t.string "lon"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "contact_name"
    t.string "contact_phone"
    t.boolean "credit_accepted"
  end
  add_foreign_key "market_vendors", "markets"
  add_foreign_key "market_vendors", "vendors"
```
