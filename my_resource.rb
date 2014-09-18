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

  def queue(process, demand)
    waiting_list.push([process, demand])
  end
end