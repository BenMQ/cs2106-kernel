require_relative 'my_process'
require_relative 'init_process'
require_relative 'my_resource'
require_relative 'ready_list'

ready_list = ReadyList.new
r1 = MyResource.new(1)
r2 = MyResource.new(2)

init = InitProcess.new
ready_list.add(init)
init.run

# init.timeout

init.req(r1, 1)

puts r1

init.release(r1)
puts r1

ready_list.debug