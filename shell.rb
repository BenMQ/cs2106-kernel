require_relative 'my_process'
require_relative 'init_process'
require_relative 'ready_list'

ready_list = ReadyList.new
init = InitProcess.new
ready_list.add(init)
init.run

ready_list.debug