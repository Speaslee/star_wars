class CreateTables < ActiveRecord::Migration
  def change
      create_table :characters do |t|
        t.string :url
        t.string :name
        t.text :prelude
        t.string :gender
        t.string :homeworld
        t.string :species
        t.string :image_url

    end

    create_table :affiliations do |t|
      t.string :name
    end

    create_table :memberships do |t|
      t.integer :character_id
      t.integer :affiliation_id
    end
  end
end
