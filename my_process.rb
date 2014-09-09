class MyProcess

  attr_accessor :pid, :other_resources, :status, :status_list, :parent, :children, :priority

  def initialize(pid, priority, parent)
    @pid = pid
    @other_resources = []
    @status = :ready
    @status_list = nil
    @parent = parent
    @children = []
    @priority = priority
  end

  def to_s
    return "#{@pid} (#{@priority}): #{@status}"
  end



end