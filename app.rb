require 'sinatra/base'

require './db/setup'
require './lib/all'

class App < Sinatra::Base
  get "/:name" do
    s_name = params[:name]
    Character.where ({name: "Spock"})


    {
      name: "Spock",
      species: "Vulcan",
      gender: "Male",
      homeworld: "Vulcan",
      prelude: "Live long and prosper",
      image_url: "http://images2.fanpop.com/image/photos/10800000/Mr-Spock-mr-spock-10874060-1036-730.jpg"
    }.to_json

  end


  get "/:affiliation" do
  end
end

App.run!
