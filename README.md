mkdir devise

git clone https://github.com/YouraSilin/devise.git devise

docker compose build

docker compose run --no-deps devise_web rails new . --force --database=postgresql --css=bootstrap

replace this file https://github.com/YouraSilin/devise/blob/main/config/database.yml

  default: &default
  adapter: postgresql
  encoding: unicode
  host: devise_db
  username: postgres
  password: password
  pool: 5

  development:
    <<: *default
    database: devise_development
  
  
  test:
    <<: *default
    database: devise_test
  
docker compose up