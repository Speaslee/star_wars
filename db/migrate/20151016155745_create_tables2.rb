class CreateTables < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :character_name
      t.string :character_image_url
    end
  end
end
