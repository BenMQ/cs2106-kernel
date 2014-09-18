require_relative 'my_process'
require_relative 'init_process'
require_relative 'ready_list'

ready_list = ReadyList.new
p = MyProcess.new('init', 2, nil)
ready_list.add(p)


ready_list.debug