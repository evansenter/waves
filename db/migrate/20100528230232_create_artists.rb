class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |table|
      table.string  :name
      table.string  :mbid
      table.timestamps
    end
    
    add_index :artists, :name
  end

  def self.down
    drop_table :artists
  end
end
