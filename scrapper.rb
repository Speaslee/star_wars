require "pry"
require "./db/setup"
require "./lib/all"
binding.pry
Character.new.populate_table
