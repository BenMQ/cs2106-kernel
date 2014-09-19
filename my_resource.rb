require_relative 'const'
class MyResource
  attr_accessor :rid, :units, :free, :waiting_list

  @@resources = {}
  # Initialise a new resource with a given id
  # The total number of units for this resource
  # is equal to the id of the resource
  def initialize(rid)
    @rid = rid
    @units = rid[1..-1].to_i
    @free = @units
    @waiting_list = []
    @@resources[rid] = self
  end

  def self.init
    (1..Const::RESOURCES).each do |n|
      self.new("R#{n}")
    end
  end

  def self.get(rid)
    @@resources[rid]
  end

  def remove(process)
    @waiting_list.delete(process)
  end
  def allocate(demand)
    @free -= demand
  end

  def release(amount)
    @free += amount
    try_allocate_next
  end

  def queue(process, demand)
    waiting_list.push([process, demand])
  end

  # Attempt to allocate resources to the next pending process
  # in the waiting list, as long as the first process requires
  # less than or equals to what is currently available
  def try_allocate_next
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