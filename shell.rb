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

def create(pid, priority)
  current = $ready_list.current
  p = MyProcess.new(pid, priority, current)
  $ready_list.add(p)

  scheduler
end

def destroy(pid)
  target = MyProcess.get(pid)
  current = $ready_list.current
  if current.is_parent_of target
    target.destroy
  else
    raise 'Target is not a child'
  end
end

def to
  current = $ready_list.current
  current.timeout

  scheduler
end

def req(rid, demand)
  current = $ready_list.current
  resource = MyResource.get(rid)
  current.req(resource, demand)

  scheduler
end

init
create('x', 1)
create('y', 2)
destroy('x')
req('R1', 1)
to
req('R1', 1)



$ready_list.debug