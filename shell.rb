require_relative 'my_process'
require_relative 'init_process'
require_relative 'my_resource'
require_relative 'ready_list'

ready_list = ReadyList.new
MyProcess.ready_list = ready_list
r1 = MyResource.new(4)
r2 = MyResource.new(2)

init = InitProcess.new
p1 = MyProcess.new('A', 1, init)
ready_list.add(init)
ready_list.add(p1)
init.run

# init.timeout

init.req(r1, 1)
p1.req(r1, 4)
puts p1
puts r1

init.release(r1)
puts r1

ready_list.debug