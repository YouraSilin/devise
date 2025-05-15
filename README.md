  mkdir devise

git clone https://github.com/YouraSilin/devise.git devise

cd devise

docker compose build

docker compose run --no-deps web rails new . --force --database=postgresql --css=bootstrap

replace this file https://github.com/YouraSilin/devise/blob/main/config/database.yml
  
docker compose up

docker compose exec web rake db:create db:migrate

sudo chown -R $USER:$USER .

add this line to Gemfile:

   gem "devise"

docker compose exec web bundle install

docker compose exec web rails generate devise:install

docker compose exec web rails generate devise User

docker compose exec web rails generate migration AddRoleToUsers role:string

docker compose exec web rails db:migrate

sudo chown -R $USER:$USER .

Here is a possible configuration for config/environments/development.rb:

config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

В файл app/views/layouts/application.html.erb добавьте:

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

Пример: создадим ресурс Posts.

docker compose exec web rails generate scaffold Post title:string content:text

docker compose exec web rails db:migrate

Ограничиваем доступ в контроллере:

Модифицируйте PostsController:

class PostsController < ApplicationController

  before_action :authenticate_user!
  
  before_action :authorize_admin, only: [:edit, :update, :destroy]

  \# Только администратор может редактировать и удалять
  
  def authorize_admin
  
    redirect_to root_path, alert: 'У вас нет прав для этого действия.' unless current_user.admin?
  
  end

end

Добавьте проверку прав администратора в представления, где доступны действия редактирования и удаления:

<% if current_user&.admin? %>
  
  <%= link_to 'Редактировать', edit_post_path(post) %>
  
  <%= link_to 'Удалить', post_path(post), method: :delete, data: { confirm: 'Вы уверены?' } %>

<% end %>

Добавление администратоа

docker compose exec web rails c

Найдите пользователя, который должен стать администратором:

user = User.find_by(email: "email@example.com")

Установите ему роль admin:

user.update(role: "admin")
