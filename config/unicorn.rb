# Minimal sample configuration file for Unicorn (not Rack) when used
# with daemonization (unicorn -D) started in your working directory.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
# See also http://unicorn.bogomips.org/examples/unicorn.conf.rb for
# a more verbose configuration using more features.

#stderr_path "/tmp/unicorn.log"
#stdout_path "/tmp/unicorn.log"

listen 3000 # by default Unicorn listens on port 8080
worker_processes 1 # this should be >= nr_cpus
pid "/tmp/unicorn.pid"
timeout 300