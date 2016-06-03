class Seeder
require 'date'
  def self.seed!
    self.categories
    self.items
    self.users
    self.day
    self.event
    self.dayEvents
  end


  def self.categories
    Category.create(name: "Matte")
    Category.create(name: "Fysik")
  end

  def self.usercategories
    UserCategory.create(user_id: 2, category_id: 2)
  end

  def self.items
    Item.create(name: "Läxa 3",
                category_id: 1)
    Item.create(name: "Inlämningen",
                category_id: 2)
  end



  def self.users
    User.create(username: 'Grabben',
                password: 'tjena')
  end

  def self.dayEvents
    DayEvent.create(day_id: 1,
                    user_id: 1,
                    event_id:1)
  end


  def self.event
    Event.create(name: 'Tjena')
  end




  def self.day
    day = Date.today
    1000.times do
      year = Year.first_or_create(year: day.year.to_s)
      month = Month.first_or_create(name: Date::MONTHNAMES[day.month], year_id: year.id)
      week = Week.first_or_create(week:day.cweek, month_id: month.id)


      Day.create(name: Date::DAYNAMES[day.wday],mday: day.mday,week_id: week.week, month_id: month.id, year_id: year.id, wday: day.wday)
      day = day.next
    end
  end




end