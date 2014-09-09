class WaitingList
  def initialize
    @lists = Array.new(Const::MAX_PRIORITY) {[]}
  end

  def add(process, priority)
    if priority < 0 || priority > Const::MAX_PRIORITY
      puts "Error: Illegal priority, #{priority} given."
    end

    @lists[priority].push(process)
    process.status_list = @lists[priority]
  end

  def remove(process)
    @lists.each do |list|
      break unless list.remove(process).nil?
    end
  end

  def debug
    @lists.each do |list, index|
      puts "Priority #{index}: #{list}"
    end
  end
end