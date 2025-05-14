mkdir devise

git clone https://github.com/YouraSilin/devise.git devise

cd devise

docker compose build

docker compose run --no-deps web rails new . --force --database=postgresql --css=bootstrap

replace this file https://github.com/YouraSilin/devise/blob/main/config/database.yml
  
docker compose up

docker compose exec web rake db:create db:migrate

sudo chown -R $USER:$USER .

docker compose exec web rails generate devise:install

docker compose exec web rails generate devise User

rails db:migrate

rails generate migration AddRoleToUsers role:string

rails db:migrate

rails c User.update_all(role: 'viewer')
