def distribute()
  @prop = Distribution.where(:proportion > 0, :size > 1).all
  @sum = 0
  @prop.each{|p|
    @sum += p.proportion
  }
  if @sum == 0
    @prop = [{size: 2, proportion: 1}, {size: 3, proportion: 1}] # As many 2s than 3s
    @sum = 2
  end

  @small = @prop[0].size
  @prop.each{|p| @small = p.size if p.size < @small}
  @portions = 1
  @reqs = Lunchrequest.all
  @newLunches = []
  @newLunches = endTest(@newLunches, @small)

  # DELETE ALL REQUESTS
end

def endTest(@newLunches, @small)
  @reqs = Lunchrequest.all
  if @reqs.size < @small
    case @reqs.size
    when 0
      return
    when 1
      @goodLunch = @newLunches.select{|l| l.time == @reqs[0].time && l.users.size == @small}
      if @goodLunch[0]
        @newLunches[@newLunches.index(@goodLunch[0])].users << reqs.user_id
        return @newLunches
    else

  end
end

scheduler = Rufus::Scheduler.new

scheduler.cron '0,10,20,30,40,50 7-12 * * *' do # Do something every 10 minutes from 7:00 to 12:50
  distribute()
end
