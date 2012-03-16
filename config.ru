ROOT = ::File.dirname(::File.realdirpath(__FILE__))
require "#{ROOT}/lib/sras.rb"
run SRAS.new
