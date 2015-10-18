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
        elsif l.href.include?("jedipedia")|| l.href.include?("http://api.wikia.com/")||l.href.include?("%C3%")|| l.href.include?("Forum:")
          next
        elsif
         l.href.include?("ow.ly")|| l.href== nil || l.href.include?("?") || l.href.include?("Polic") || l.href.include?("Article") || l.text == "Status Articles" || l.text == "Browse articles by category"  || l.text == "Contact" || l.text == "Forums"
            next
          elsif l.href.include?("talk") || l.href.include?("Movie") ||l.href.include?("Music") ||l.href.include?("Comics") ||l.href.include?("Games") ||l.href.include?("Books") ||l.href.include?("TV") || l.href.include?("bnc.lt/m")
            next
          elsif l.href.include?("Kategori") || l.href.include?("Ategor%C3%ADa:Individuos_de_la_Alianza_Gal%C3%A1ctica") || l.href.include?("Cat%C3%A9gorie") || l.href.include?("%D0%B8")|| l.href.include?("https://bnc.lt/m/QdCznZAAym")
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
        puts "you've saved #{potential_character_links.uniq.count} unique links"
        nu_page =  sub_sub_categories.first.click
        puts "now on #{nu_page.uri}"
        visited_page.push(sub_sub_categories.first.href)
        sub_sub_categories.shift
        sub_categories.push(nu_page)
      end
      if !sub_sub_categories.any? || visited_page.count == 300 #was added for sake of not spending weekend running loop
        break
      end
    end


    character_links = []
    slimed = potential_character_links.uniq
    slimed.each do |l|

      if l.href.include?("About")|| l.href== nil || l.text == "Lifestyle" || l.href.include?("Entertainment") || l.text == "Administrators' noticeboard" || l.text == "Wookieepedia in other languages" || l.text == "Browse articles by category"  || l.text == "On the Wiki" || l.text == "Main page"
        next
      elsif l.href.include?("talk") || l.href.include?("Lifestyle_Hub") ||l.href.include?("Music") ||l.href.include?("Comics") ||l.href.include?("Games") ||l.href.include?("Books") ||l.href.include?("TV")||l.href.include?("http://www.wikia.com")
        next
      elsif l.href.include?("Kategori") || l.href.include?("Ategor%C3%ADa:Individuos_de_la_Alianza_Gal%C3%A1ctica") || l.href.include?("Cat%C3%A9gorie") || l.href.include?("Help") || l.text =="Español" ||l.href.include?("#")|| l.href.include?("Main_Page")
        next
      else
        character_links.push l
        print l.href
        puts character_links.count
      end

    end


    character_links.each do |page|
      page = character_links.first.click
      puts "now on #{page.uri}"
      character_links.shift
    bio_table = page.search("#Character_infobox")
    if bio_table.count == 1

    rows = bio_table.search "tr"

    results = {}
      rows.each do |r|
        cells = r.search "td"
        if cells.count == 2
          key   = cells.first.text.strip
          value = cells.last.text.strip

          results[key] = value
        end
      end

      #

    #make yourself

    nu_char = Character.new(
    name: page.search("#mw-content-text").search("p").search("b").first,
    species: results["Species"],
    gender: results["Gender"],
    homeworld: results["Homeworld"],
    prelude: page.search('#mw-content-text > p').map { |s| s.text.chomp }.first(5).join("\n"),
    image_url: bio_table.search("tr").search("td").search("a").first["href"]
    )

    begin
      nu_char.save!
    rescue => e
      puts "Failed to save #{nu_char} - #{e}"
    end

    #make membership table
    results["Affiliation"]

  #make affiliation table
  if results["Affiliation"]
    c = results["Affiliation"].split("\n")
        c.each do |m|
          s = m.split("[")[0]
      nu_affiliation = Affiliation.new(
      name: s
      )
      begin
        nu_affiliation.save!
      rescue => e
        puts "Failed to save #{nu_affiliation} - #{e}"
      end
    end
  end
  #  make affiliation table
    if results["Affiliation"]

      c = results["Affiliation"].split("\n")
      c.each do |m|
        s = m.split("[")[0]



         d = Affiliation.where(name:"#{s}")
        q = Character.last
        Character.last.memberships.create affiliation: d.first
      end
    end
  end
end
end
end
