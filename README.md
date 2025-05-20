mkdir devise

git clone https://github.com/YouraSilin/devise.git devise

cd devise

docker compose build

docker compose run --no-deps web rails new . --force --database=postgresql --css=bootstrap

replace this files

https://github.com/YouraSilin/devise/blob/main/config/database.yml

https://github.com/YouraSilin/devise/blob/main/Dockerfile

https://github.com/YouraSilin/devise/blob/main/Gemfile

docker compose up

docker compose exec web rake db:create db:migrate

sudo chown -R $USER:$USER .

docker compose exec web rails generate devise:install

docker compose exec web rails generate devise User

docker compose exec web rails generate migration AddRoleToUsers role:string

docker compose exec web rails db:migrate

sudo chown -R $USER:$USER .


Here is a possible configuration for config/environments/development.rb:

config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

В файл app/views/layouts/application.html.erb добавьте:

      <% if flash[:alert] %>
        <div class="alert alert-danger">
          <%= flash[:alert] %>
        </div>
      <% end %>
    
      <% if flash[:notice] %>
        <div class="alert alert-success">
          <%= flash[:notice] %>
        </div>
      <% end %>

&lt;p class="notice"&gt;&lt;%= notice %&gt;&lt;/p&gt;

&lt;p class="alert"&gt;&lt;%= alert %&gt;&lt;/p&gt;

Модифицируйте модель User (app/models/user.rb), чтобы задать роли:

class User < ApplicationRecord

\# Devise модули

devise :database_authenticatable, :registerable,

       :recoverable, :rememberable, :validatable

\# Установим роли

enum role: { viewer: 'viewer', admin: 'admin' }

\# Зададим роль по умолчанию

after_initialize do

  self.role ||= :viewer
  
end
  
end

Задайте дефолтную роль в консоли (для существующих пользователей).

docker compose exec web rails c "User.update_all(role: 'viewer')"

Создайте два контроллера — один для просмотра (режим просмотра) и другой для админки (режим редактирования).


