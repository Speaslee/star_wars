require 'mechanize'

require './lib/traversal.rb'

class Character < ActiveRecord::Base
validates_presence_of :name
validates_uniqueness_of :name

has_many :memberships
has_many :affiliations, through: :memberships

  def populate_table
    agent = Mechanize.new
    page1 = agent.get "http://starwars.wikia.com/"
    link = page1.link_with(text: 'characters')
    page2 = link.click
    link = page2.link_with(text: 'Individuals by faction')
    page = link.click.go!



    bio_table = page.search("Character_infobox")
    rows = bio_table.search "tr"

    results = {}
    rows.each do |r|
    cell = r.search "td"
    if cells.count == 2
      key = cells.first.downcase.text
      value = cells.last.text
      results[key] = value

      end

    results[affiliations].value
    end
#make affiliation table
      clubs = results["affiliation"].value.to_a
      clubs.each do |s|
        Affiliation.make_affiliation s
      end


#make yourself
    self.create(
      name: page.search("p","b").first,
      species: results["species"].value,
      gender: results["gender"].value,
      homeworld: results["homeworld"].value,
      prelude: page.search(p).first(5),
      image_url:bio_table.search("tr").search("td").search("a").href.first
    )

    #make membership table
        c = results["affiliation"].value.to_a
        self.memberships.create! affiliation: c

   end
#
#
#


end
