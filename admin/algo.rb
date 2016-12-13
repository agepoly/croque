def distribute
  # Creation of distribution objects
  @prop = Distribution.where { (proportion > 0) }.all.select { |d| d.size > 1 }
  @sum = 0
  @prop.each do |p|
    @sum += p.proportion
  end
  # Default distribution if this one is not valid
  if @sum.zero?
    @prop = [{ size: 2, proportion: 1 }, { size: 3, proportion: 1 }] # As many 2s than 3s
    @sum = 2
  end

  @small = @prop[0].size
  @prop.each { |p| @small = p.size if p.size < @small }
  @portions = 1
  @reqs = Lunchrequest.all

  # Find all tables for a specific time
  def findTable(time)
    @exact = @prop.index { |p| p.size == Lunchrequest.where(time: time).all.size }
    if !@exact.nil?
      createLunch(@prop[@exact][:proportion], time)
    else
      @rand = rand(@sum)
      @te = 0
      @count = 0
      while @rand > @te
        @te += @prop[@count][:proportion]
        @count += 1
      end
      createLunch(@prop[@count].size, time)
    end
  end

  # Create a lunch for num persons at the specified time
  def createLunch(num, time)
    log = Logger.new(STDERR)
    log.fatal(num)
    log.fatal(time)

    @timeReqs = Lunchrequest.where(time: time).all
    @chosen = @timeReqs.first(num)
    @lunch = Lunch.new(time: time, date: Date.today).save
    @chosen.each do |req|
      @lunch.add_user(req[:user_id])
      req.delete
    end
  end


  @times = [11, 12, 13]

  # Create tables for each time slot
  for @time in @times do
    findTable(@time) while Lunchrequest.where(time: @time).all.size >= @small
  end
end


scheduler = Rufus::Scheduler.new

scheduler.cron '0,10,20,30,40,50 7-12 * * *' do # Do something every 10 minutes from 7:00 to 12:50
  distribute
end
