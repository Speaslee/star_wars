require 'mechanize'

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
    page = link.click

      visited_links = []
      good_links = []

      page.links.each do |l|
        if l.href== nil || l.href.include?("?") || l.href.include?("Policies") || l.text == "Articles" || l.text == "Status Articles" || l.text == "Browse articles by category"  || l.text == "Contact" || l.text == "Forums" || l.href.include?("talk")
          next
        elsif l.href.include?("Category") == false
          next
        end
        good_links.push l
      end

      potential_character_links = []
      sub_categories = []

      loop do
      if good_links.any?
      good_links.each do |l|
        l = good_links.first.click
        good_links.shift
        sub_categories.push l
          end
      else
        break
      end
      sub_categories
      end

loop do
  sub_sub_categories = []

  if sub_categories.any?

    sub_categories.links.each do |l|
      if l.href== nil || l.href.include?("?") || l.href.include?("Policies") || l.text == "Articles" || l.text == "Status Articles" || l.text == "Browse articles by category"  || l.text == "Contact" || l.text == "Forums" || l.href.include?("talk")
        next
      elsif l.href.include?("Category")== false && l.href.include?("Special")== false && l.href.include?("Wookieepedia")== false
        potential_character_links.push l
      else
      sub_sub_categories.push l
    end
  end

    binding.pry
    sub_categories.links.each
      t = sub_categories.first.click
      sub_categories.shift
      sub_categories.push t
    end
  end
    binding.pry
  else
    sub_sub_categories = sub_categories
  when sub_sub_categories.any? == false && sub_categories.any? == false
    break
  end
  puts potential_character_links
end


  binding.pry



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
