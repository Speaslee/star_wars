require 'sinatra/base'

require './db/setup'
require './lib/all'

class App < Sinatra::Base


  get "/character/:name" do

  s_name = params[:name]
  s = Character.where('name LIKE ?', '%"#{s_name}%"').all
  # s_id = params[:id]
  # s = Character.find s_id
# works when you search by character id. Does not work if you search by name
  affiliation_hashes = s.affiliations.map do |u|
    { name: u.name }
  end





{
      results: [{
      name: s.name.split("\n")[0],#added because of database population mistake. Fixed mistake for future populations but did not want to rerun populate_table. Could character update instead but nah.
      species: s.species,
      gender: s.gender,
      homeworld: s.homeworld,
      image_name: s.name.split[0]+ s.id.to_s + ".jpg",
      image_url: s.image_url,
      prelude: s.prelude,
      affiliation: affiliation_hashes
    }]
    }.to_json


  end



  get "/affiliation/:affiliation" do
    t_name = params[:affiliation]
    t = Affiliation.where('name LIKE ?', '%"#{t_name}%"').all


    character_hashes = t.characters.map do |u|
      { name: u.name.split("\n")[0], }
    end

{
      results: [{
        name: t.name,
        characters: character_hashes
    }]
  }.to_json
  end
end


App.run!
