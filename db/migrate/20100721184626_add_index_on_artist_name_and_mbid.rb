class AddIndexOnArtistNameAndMbid < ActiveRecord::Migration
  def self.up
    add_index :artists, :name
    add_index :artists, :mbid
  end

  def self.down
    remove_index :artists, :name
    remove_index :artists, :mbid
  end
end
