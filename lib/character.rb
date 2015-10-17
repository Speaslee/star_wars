require 'mechanize'

class Character < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :memberships
  has_many :affiliations, through: :memberships
  #all of this is terrible, never do this. Abandon hope all ye who enter here
  def populate_table
    agent = Mechanize.new
    page1 = agent.get "http://starwars.wikia.com/"
    link = page1.link_with(text: 'characters')
    page2 = link.click
    link = page2.link_with(text: 'Individuals by faction')
    page3 = link.click

    visited_links = []
    good_links = []

    page3.links.each do |l|
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

    sub_sub_categories = []
    visited_page = []
    loop do


      links = sub_categories.uniq.map{ |t| t.links }.flatten
      links.each do |l|

        if l.href== nil || l.href.include?("?") || l.href.include?("Policies") || l.text == "Articles" || l.text == "Status Articles" || l.text == "Browse articles by category"  || l.text == "Contact" || l.text == "Forums" || l.href.include?("talk")
          next
        elsif l.href.include?("jedipedia")
          next
        elsif l.href.include?("Category")== false && l.href.include?("Special")== false && l.href.include?("Wookieepedia")== false && !potential_character_links.include?(l)
          potential_character_links.push l
          next
        elsif l.href.include?("Category")&& l.href.include?("Individuals_by_faction")== false
          sub_sub_categories.push l
        end
      end
      #

      if visited_page.include?(sub_sub_categories.first.href)
        sub_sub_categories.shift
      else
        puts "visited_page is #{visited_page.count}"
        nu_page =  sub_sub_categories.first.click
        puts "now on #{nu_page.uri}"
        visited_page.push(sub_sub_categories.first.href)
        sub_sub_categories.shift
        sub_categories.push(nu_page)
      end
      if !sub_sub_categories.any? || visited_page.count == 300
        break
      end
    end


    character_links = []
    slimed = potential_character_links.uniq
    slimed.each do |l|

      if l.href.include?("ow.ly")|| l.href== nil || l.href.include?("?") || l.href.include?("Polic") || l.text == "Articles" || l.text == "Status Articles" || l.text == "Browse articles by category"  || l.text == "Contact" || l.text == "Forums"
        next
      elsif l.href.include?("talk") || l.href.include?("Movie") ||l.href.include?("Music") ||l.href.include?("Comics") ||l.href.include?("Games") ||l.href.include?("Books") ||l.href.include?("TV")
        next
      else
        character_links.push l

      end

    end


    character_links.each do |link|
      page = link.click
    end

    bio_table = page.search("#Character_infobox")
    rows = bio_table.search "tr"

    results = {}
    rows.each do |r|
      cells = r.search "td"
      if cells.count == 2
        key = cells.first.text.downcase.strip
        value = cells.last.text.strip

        results[key] = value
      end

      #
      results[affiliations].value
    end
    make affiliation table
    if results[]
      clubs = results["affiliation"].to_a
      clubs.each do |s|
        Affiliation.make_affiliation s
      end
    end
    #make yourself
    
    nu_char = Character.new(
    name: page.search("#mw-content-text").search("p").search("b").first,
    species: results["species"],
    gender: results["gender"],
    homeworld: results["homeworld"],
    prelude: page.search("#mw-content-text").first(5),
    image_url: bio_table.search("tr").search("td").search("a").first["href"]
    )

    begin
      nu_char.save!
    rescue => e
      puts "Failed to save #{nu_char} - #{e}"
    end

    #make membership table
    make affiliation table
    if results["affiliation"]

      c = results["affiliation"].to_a
      c.each do |s|
        self.memberships.create! affiliation: s
      end
    end
  end
end
