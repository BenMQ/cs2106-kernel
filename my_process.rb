class MyProcess
  @@ready_list = nil

  # Hash of all processes keyed by their PID
  @@processes = {}
  attr_accessor :pid, :other_resources, :status, :status_list, :parent, :children, :priority, :ready_list

  def self.init(ready_list)
    @@ready_list = ready_list
    @@processes = {}
  end

  def self.get(pid)
    @@processes[pid]
  end

  # Initialise a process with given pid, priority and (optionally) a parent
  # The newly created process has a default status of ready
  def initialize(pid, priority, parent)
    if not priority.between?(0, Const::MAX_PRIORITY)
      raise 'Invalid priority'
    end

    if @@processes.has_key?(pid)
      raise 'Duplicate PID'
    end

    @pid = pid
    @other_resources = {}
    @status = :ready
    @status_list = nil
    @parent = parent
    @children = []
    @priority = priority

    # Creation tree points both ways
    parent.add_child(self) unless parent.nil?
    @@processes[pid] = self
  end

  # Add a child to a parent process
  def add_child(child)
    @children.push(child)
  end

  # Check if self is parent of another process
  # Recursively checks the child's parent until
  # 1) Self is reached, hence it's a ancestor
  # 2) Nil is reached (root of the creation tree), hence it's not a ancestor
  def is_ancestor_of(child)
    if child.parent.nil?
      false
    elsif child == self
      true
    else
      is_ancestor_of child.parent
    end
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

  def destroy
    # Recursively destroy children first
    @children.each do |p|
      p.destroy
    end

    # Release all resources
    @other_resources.each_pair do |rid, units|
      release_by_rid(rid, units)
    end

    # Remove pointers in status_list
    if @status == :blocked
      @status_list.delete_if {|a| a[0] == self}
    else
      @status_list.remove(self)
    end

    # Remove pointers in children list
    @parent.children.delete(self)

    # Release PID
    @@processes.delete(@pid)

    @status = :destroyed
  end

  # request x units from a given resource
  def req(resource, units)
    if units < 0
      raise 'Invalid units to request'
    end

    if resource.free >= units
      resource.allocate(units)
      if @other_resources[resource.rid]
        @other_resources[resource.rid] += units
      else
        @other_resources[resource.rid] = units
      end
    else
      @status = :blocked
      @status_list.remove(self)
      @status_list = resource.waiting_list
      resource.queue(self, units)
    end
  end

  # Release the resource that is currently allocated to the process
  def release(resource, units)
    if units < 0
      raise 'Invalid units to request'
    end

    if @other_resources.has_key?(resource.rid) and @other_resources[resource.rid] >= units
      resource.release(units)
      @other_resources[resource.rid] -= units
    else
      raise 'Requested number of units to release is less than total number of units allocated'
    end
  end

  # Helper when deleting a process
  def release_by_rid(rid, units)
    release(MyResource.get(rid), units)
  end

  def scheduler
    highest = @@ready_list.highest_priority
    if @priority < highest.priority || @status != :running
      # status is running because
      # 1) A timeout is issued
      # 2) A new process with higher priority is created
      if @status == :running
        @status = :ready
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