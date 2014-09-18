require_relative 'const'
class ReadyList
  attr_accessor :lists

  # Initialise a ready list, with priority level set in Const::MAX_PRIORITY
  def initialize
    @lists = Array.new(Const::MAX_PRIORITY + 1) {Array.new}
  end

  # Add a new process to the ready list
  # Since the priority is static, we can retrieve the priority from the process
  # directly instead of taking it in as an argument
  def add(process)
    remove(process)

    priority = process.priority
    @lists[priority].push(process)
    process.status_list = @lists[priority]
  end

  # Remove a given process from the ready list
  def remove(process)
    @lists.each do |list|
      break unless list.delete(process).nil?
    end
  end

  def debug
    @lists.each_with_index do |list, index|
      puts "Priority #{index}: #{list.to_s}"
    end
  end
end
