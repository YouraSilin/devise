mkdir devise

git clone https://github.com/YouraSilin/devise.git devise

cd devise

docker compose build

docker compose run --no-deps devise_web rails new . --force --database=postgresql --css=bootstrap

replace this file https://github.com/YouraSilin/devise/blob/main/config/database.yml
  
docker compose up
