mkdir newapp

git clone https://github.com/YouraSilin/newapp.git newapp

cd newapp

docker compose build

docker compose run --no-deps web rails new . --force --database=postgresql --css=bootstrap

docker compose up

docker compose exec web rake db:create db:migrate
