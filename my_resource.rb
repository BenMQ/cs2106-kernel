class MyResource
  attr_accessor :rid, :units, :free, :waiting_list

  # Initialise a new resource with a given id
  # The total number of units for this resource
  # is equal to the id of the resource
  def initialize(rid)
    @rid = rid
    @units = rid.to_i
    @free = rid.to_i
    @waiting_list = []
  end

  def allocate(demand)
    @free -= demand
  end

  def release(amount)
    @free += amount
  end

  def queue(process, demand)
    waiting_list.push([process, demand])
  end

  # Attempt to allocate resources to the next pending process
  # in the waiting list, as long as the first process requires
  # less than or equals to what is currently available
  def try_allocate
    while not @waiting_list.empty? and @waiting_list.first[1] <= @free do
      first = @waiting_list.pop
      first[0].req(self, first[1])
      first[0].ready
    end
  end

  def to_s
    return "#{rid}: #{free} / #{units}"
  end

  def inspect
    to_s
  end
end