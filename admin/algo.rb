def distribute
  # Creation of distribution objects
  @prop = Distribution.where { (proportion > 0) }.all.select { |d| d.size > 1 }
  @sum = 0
  @prop.each do |p|
    @sum += p.proportion
  end
  if @sum.zero?
    @prop = [{ size: 2, proportion: 1 }, { size: 3, proportion: 1 }] # As many 2s than 3s
    @sum = 2
  end

  @small = @prop[0].size
  @prop.each { |p| @small = p.size if p.size < @small }
  @portions = 1
  @reqs = Lunchrequest.all

  @times = [11, 12, 13]

  for @time in @times do
    findTable(@time) while Lunchrequest.where(time: @time).all.size >= @small
end

  # @newLunches = []
  # @newLunches = endTest(@newLunches, @small)

  # DELETE ALL REQUESTS
end

def findTable(time)
  @reqs = Lunchrequest.all
  @small = @prop[0].size
  @prop = Distribution.where { (proportion > 0) }.all.select { |d| (d.size < @reqs.size) && (d.size > 1) }
  @sum = 0
  @prop.each do |p|
    @sum += p.proportion
  end
  if @sum.zero?
    @prop = [{ size: 2, proportion: 1 }, { size: 3, proportion: 1 }] # As many 2s than 3s
    @sum = 2
  end
  @prop.each { |p| @small = p.size if p.size < @small }
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

def createLunch(num, time)
  log = Logger.new(STDERR)
  log.fatal(num)
  log.fatal(time)

  @reqs = Lunchrequest.where(time: time).all
  @chosen = @reqs.first(num)
  @lunch = Lunch.new(time: time, date: Date.today).save
  @chosen.each do |req|
    @lunch.add_user(req[:user_id])
    req.delete
  end
end

scheduler = Rufus::Scheduler.new

scheduler.cron '0,10,20,30,40,50 7-12 * * *' do # Do something every 10 minutes from 7:00 to 12:50
  distribute
end
