class InitProcess < MyProcess

  def initialize
    @pid = 'init'
    @other_resources = []
    @status = :ready
    @status_list = nil
    @parent = nil
    @children = []
    @priority = 0
  end

end