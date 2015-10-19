require 'sinatra/base'

require './db/setup'
require './lib/all'

class App < Sinatra::Base


  get "/character/:name" do
  #   s_name = params[:name]
  # s = Character.where ({name: s_name})
  #
  #
  #    {
  #      results: [{
  #     name: "Spock",
  #     species: "Vulcan",
  #     gender: "Male",
  #     homeworld: "Vulcan",
  #     prelude: "Live long and prosper",
  #     image_name: s.name + ".jpg",
  #     image_url:"http://images2.fanpop.com/image/photos/10800000/Mr-Spock-mr-spock-10874060-1036-730.jpg"
  #
  #   },
  #   {
  #     name:"Spock Nu",
  #     species: "Human",
  #     gender: "Male",
  #     homeworld: "Vulcan",
  #     prelude: "Live long and prosper",
  #     image_url: "http://images2.fanpop.com/image/photos/10800000/Mr-Spock-mr-spock-10874060-1036-730.jpg"
  #   }]
  # }.to_json

  s_name = params[:name]
  s = Character.where('name LIKE ?', '%#{s_name}%').all

# if s.affiliation.any?
#   affiliation_hashes = s.affiliations.map do |u|
#     { name: u.name }
#   end
# end





      results= {
      name: s.name,
      species: s.species,
      gender: s.gender,
      homeworld: s.homeworld,
      image_name: s.name + ".jpg",
      image_url: s.image_url,
      # affiliation: affiliation_hashes

    }.to_json


  end


  get "/affiliation/:affiliation" do
    t_name = params[:affiliation]
    t = Affiliation.find t_name

    character_hashes = t.characters.map do |u|
      { name: u.name }
    end


      results = {
        name: t.name,
        characters: character_hashes
    }.to_json
  end
end

App.run!
