pids = `pgrep -f push`.split("\n")
#{File.dirname(__FILE__)}/../../config/environment.rb
`ruby -- #{File.dirname(__FILE__)}/push.rb &` if pids.size == 0