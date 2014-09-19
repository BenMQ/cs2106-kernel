class MyProcess
  @@ready_list = nil
  attr_accessor :pid, :other_resources, :status, :status_list, :parent, :children, :priority

  def self.ready_list=(ready_list)
     @@ready_list = ready_list
  end

  def self.ready_list
    @@ready_list
  end

  # Initialise a process with given pid, priority and (optionally) a parent
  # The newly created process has a default status of ready
  def initialize(pid, priority, parent)
    #TODO: check for duplicate PID, erroneous priority
    @pid = pid
    @other_resources = []
    @status = :ready
    @status_list = nil
    @parent = parent
    @children = []
    @priority = priority

    # Creation tree points both ways
    parent.add_child(self) unless parent.nil?
  end

  # Add a child to a parent process
  def add_child(child)
    @children.push(child)
  end

  def timeout
    @status = :ready
    @status_list.remove(self)
    @status_list.add(self)
  end

  def run
    @status = :running
    @status_list.current = self
  end

  def ready
    @status = :ready
    @@ready_list.add(self)

  end

  def req(resource, demand)
    if resource.free >= demand
      resource.allocate(demand)
      @other_resources.push([resource, demand])
    else
      @status = :blocked
      @status_list.remove(self)
      @status_list = resource.waiting_list
      resource.queue(self, demand)
    end
  end

  # Release the resource that is currently allocated to the process
  def release(resource)
    # TODO: Check if resource is allocated to this process currently
    allocated = @other_resources.select { |alloc| alloc[0] == resource }
    allocated.each { |alloc| resource.release(alloc[1]) }
    @other_resources.delete_if { |alloc| alloc[0] == resource }

    resource.try_allocate
  end

  def scheduler
    highest = @@ready_list.highest_priority
    if @priority < highest.priority
      if @status == :running
        timeout
      end
      highest.run
    end
  end

  def to_s
    return "#{@pid} (#{@priority}): #{@status}"
  end

  def inspect
    self.to_s
  end



end