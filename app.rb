#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'SQLite3'
# метод подключения к дб
def init_db
  @db = SQLite3::Database.new 'leprosorium.db'
  @db.results_as_hash = true
end

# before выхывается каждый раз при перезагрузке любой страницы
before do
  # Инициализация дб
  init_db
end

# configure вызывается каждый раз при конфигурации приложения:
# когда изменился код программы И перезагрузилась страница

configure do
  # инициализация дб
  init_db
  # создает таблицу если таблица не существует
  @db.execute 'create table if not exists Posts
    (
       id integer primary key autoincrement,
       created_date date,
       content text
     )'
  # создает таблицу для коментариев
  @db.execute 'create table if not exists Comments
    (
       id integer primary key autoincrement,
       created_date date,
       content text,
       post_id integer
     )'
end

get '/' do
  @results = @db.execute 'select * from Posts order by id desc'
	erb :index
end

# обработчик get-запроса /New
# (браузер получает страницу с сервера)
get '/New' do
  erb :New
end

get '/Posts' do
  erb "Hello World"
end

# обрабочик пост запроса /New
# (браузер отправляет данные на сервер)

post '/New' do
  # получаем переменную из post запроса
  @content = params[:newpost]
  # проверка на пустой пост
  if @content.length <= 0
    @error = 'Type post text'
    return erb :New
  else
    # сосхранение данных в дб
    @db.execute 'insert into Posts (content, created_date) values (?,datetime())',[@content]
    redirect to('/')
  end
end
# Вывод информации о посте
get '/detail/:post_id' do
  # получаем переменную из url
  post_id = params[:post_id]
  # получаем список постов
  #(у нас будет только один пост)
  @results = @db.execute 'select * from Posts where id = ?', [post_id]
  # выбираем этот один пост
  @row = @results[0]
  erb :detail
end
# Обработчик пост запроса
#(браузер отправляет данные на сервер, мы хи принимаем)
post '/detail/:post_id' do
  # получаем переменную из юрл
  post_id = params[:post_id]
  # получение переменной из поста
  comment = params[:comment]

end
