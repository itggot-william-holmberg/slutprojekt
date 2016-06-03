class App < Sinatra::Base
  enable :sessions



  get '/' do
      @categories = Category.all
      @items = Item.all
      @users = User.all
      @user = User.get(session[:user]) if session[:user]
      if @user
        redirect '/calendar/'
      else
          if !session[:temporary_user_id]
            @temporary_user = TemporaryUser.create
            session[:temporary_user_id] = @temporary_user.id
            cat = Category.create(name: "Välkommen")
            TemporaryUserCategory.create(category_id: cat.id, temporary_user_id: @temporary_user.id)
            Item.create(name: "Skapa din första todo", category_id: cat.id)
          else
            @temporary_user = TemporaryUser.first(:id => session[:temporary_user_id])
        end
        slim :index
      end
  end

  get '/testindex' do
    @user = User.get(session[:user]) if session[:user]
    if !@user.nil?
      @user_categories = UserCategory.all(:user_id => @user.id)
    end
    slim :testIndex
  end

  get '/logout' do
    session.clear
    redirect '/'
  end


  post '/newTemporaryCategory/' do

    message = params['message'].to_s
    if !message.to_s.empty?
      cat = Category.create(name: message)
      TemporaryUserCategory.create(temporary_user_id: session[:temporary_user_id], category_id: cat.id)
      redirect back
    else
      redirect '/didntwork'
    end
  end


  post '/newCategory/' do
    message = params['message'].to_s
    if !message.to_s.empty?
      Category.create(name: message)
      redirect back
    else
      redirect '/didntwork'
    end
  end

  post '/newCategory/:id' do |id|
    @user = User.get(session[:user]) if session[:user]
    times = params['repeat'].to_i
    message = params['message'].to_s

    if !message.to_s.empty?
      cat = Category.create(name: message)
      UserCategory.create(user_id: @user.id, category_id: cat.id, day_id: id)
      if times > 4
        4.times do
          id = (id.to_i + 7).to_s
          UserCategory.create(user_id: @user.id, category_id: cat.id, day_id: id)
        end
      else
        times.times do
        id = (id.to_i + 7).to_s
        UserCategory.create(user_id: @user.id, category_id: cat.id, day_id: id)
        end
      end
      redirect back
    else
      redirect '/didntworkb'
    end
  end

  post '/category/:id/item/create' do |id|
    message = params['message'].to_s
    if !message.to_s.empty?
      if !id.nil?
        Item.create(name: message,category_id: id)
      else
        "id nil"
      end
    end
    redirect back
  end

  post '/item/:id/remove' do |id|
    grabben = Item.first(:id => id)
    grabben.destroy
    redirect back
  end

  post '/user/new' do
    username = params['username']
    password = params['password']
    email = params['email']
    db_user = User.first(:username => username)
    if db_user.nil?
      User.create(username:username, password:password, email: email)
    end
    redirect back
  end

  get '/users' do
    @users = User.all
    slim :users
  end



  get '/calendar/' do
    today = Date.today
    redirect "calendar/#{today.year}/#{Date::MONTHNAMES[today.month]}/#{today.mday}/"
  end


  get '/calendar/:year/:month/:day/' do |year, month, day|
      @user = User.get(session[:user]) if session[:user]
      @year = Year.first(:year => year.to_s)
      @month = Month.first(:name => month.to_s, :year_id => @year.id)
      @current_day = Day.first(:year_id => @year.id, :month_id => @month.id, mday: day)
      @month_days = Day.all(:month_id => @month.id)

      if @user && @current_day
      @day_events = DayEvent.all(:day_id => @current_day.id, :user_id => @user.id)
      end

      if !@user.nil?
        @user_categories = UserCategory.all(:user_id => @user.id, :day_id => @current_day.id)
        slim :calendar
      else
        redirect "/notloggedinbro"
      end
  end



  get '/calendar/:year/:month/:day/prevmonth' do |year, month, day|
    @user = User.get(session[:user]) if session[:user]
    @year = Year.first(:year => year.to_s)
    @month = Month.first(:name => month.to_s, :year_id => @year.id)

    @month = Month.first(:id => (@month.id - 1))
    if !@month.nil? && @month.name == "December"
      @year = Year.first(:id => (@year.id - 1))

    end
    @current_day = Day.first(:year_id => @year.id, :month_id => @month.id, mday: 1) if !@month.nil?
    @month_days = Day.all(:month_id => @month.id) if !@month.nil?

    if @month.nil? || @year.nil? || @current_day.nil?
      redirect back
    else
      redirect "calendar/#{@year.year}/#{@month.name}/#{@current_day.mday}/"
    end
  end

  get '/calendar/:year/:month/:day/nextmonth' do |year, month, day|
    @user = User.get(session[:user]) if session[:user]
    @year = Year.first(:year => year.to_s)
    @month = Month.first(:name => month.to_s, :year_id => @year.id)

    @month = Month.first(:id => (@month.id + 1))
    if !@month.nil? &&  @month.name == "January"
      @year = Year.first(:id => (@year.id + 1))
    end
    @current_day = Day.first(:year_id => @year.id, :month_id => @month.id, mday: 1) if !@month.nil?
    @month_days = Day.all(:month_id => @month.id) if !@month.nil?

    if @month.nil? || @year.nil? || @current_day.nil?
      redirect back
    else
      redirect "calendar/#{@year.year}/#{@month.name}/#{@current_day.mday}/"

    end
  end


  post '/temporaryCategory/:id/remove' do |id|

    grabben = TemporaryUserCategory.first(:category_id => id, :temporary_user_id => session[:temporary_user_id])
    if !grabben.nil?
      grabben.destroy
      redirect back
    else
      redirect back
    end
  end

    post '/category/:id/remove' do |id|
    user = User.get(session[:user]) if session[:user]
    grabben = UserCategory.first(:category_id => id, :user_id => user.id)
    if !grabben.nil?
      grabben.destroy
      redirect back
    else
      redirect back
    end
  end

  post '/login' do
    username = params['username']
    password = params['password']
    user = authorized(username, password)
    if user
      session[:user] = user.id
      redirect '/calendar/'
    end
    slim :wrongpassword
  end

  post '/calendar/:id/new' do |id|
    event_name = params['event']
    user = User.get(session[:user]) if session[:user]
    if user
      event = Event.first(:name => event_name)
      if event
        DayEvent.create(event_id:  event.id,
                        user_id: user.id,
                        day_id: id)
      else
        DayEvent.create(event_id:  Event.create(name: event_name).id,
                        user_id: user.id,
                        day_id: id)
      end


    end
    redirect "/calendar/#{id}?/"
  end

  post '/calendar/:id/delete/:id2' do |id, id2|
    grabben = DayEvent.first(:id => id2)
    grabben.destroy
    redirect "/calendar/#{id}?"
  end

  get '/notloggedinbro' do
    slim :notloggedin
  end


end



def authorized(username, password)
  user = User.first(:username =>username)

  if user
    if user.password == password
      return user
    end
  end
  return false
end






