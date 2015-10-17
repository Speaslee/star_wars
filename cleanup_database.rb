require "pry"
require "./db/setup"
require "./lib/all"

Character.where(species: nil, homeworld: nil, gender: nil)
    t.destroy
  end
end
