require_relative 'my_process'
require_relative 'init_process'
require_relative 'my_resource'
require_relative 'ready_list'

$ready_list = nil

def scheduler
  $ready_list.current.scheduler
  print $ready_list.current.pid + ' '
  $stdout.flush
end

def init
  $ready_list = ReadyList.new
  MyProcess.init($ready_list)
  MyResource.init
  init = MyProcess.new('init', 0, nil)
  $ready_list.add(init)
  init.run

  scheduler
end

# Create process with PID and priority
def cr(pid, priority)
  raise 'Invalid priority' unless priority.between?(1, Const::MAX_PRIORITY)
  current = $ready_list.current
  p = MyProcess.new(pid, priority, current)
  $ready_list.add(p)

  scheduler
end

# Delete process PID
def de(pid)
  if pid == 'init'
    raise 'Cannot delete init process'
  end
  target = MyProcess.get(pid)
  current = $ready_list.current
  if current.is_ancestor_of target
    target.destroy
  else
    raise 'Current process is not an ancestor of target'
  end

  scheduler
end

# Issue timeout to current process
def to
  current = $ready_list.current
  current.timeout

  scheduler
end

# Request x units of resources from RID
def req(rid, units)
  current = $ready_list.current
  resource = MyResource.get(rid)
  if resource.units < units
    raise 'Requesting more units than total units for the resource'
  end
  current.req(resource, units)

  scheduler
end

# Release x units of resource from RID
def rel(rid, units)
  current = $ready_list.current
  resource = MyResource.get(rid)
  current.release(resource, units)

  scheduler
end


init

while line=gets
  begin
    command = line.chomp.split(' ')
    case command[0]
      when 'cr'
        cr command[1], command[2].to_i
      when 'de'
        de command[1]
      when 'to'
        to
      when 'req'
        req command[1], command[2].to_i
      when 'rel'
        rel command[1], command[2].to_i
      when 'init'
        puts ''
        init
    end
  rescue Exception => e
    print 'error '
  end
end
puts ''