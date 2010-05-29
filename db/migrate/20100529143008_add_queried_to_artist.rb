class AddQueriedToArtist < ActiveRecord::Migration
  def self.up
    add_column :artists, :queried, :boolean, :default => false
  end

  def self.down
    remove_column :artists, :queried
  end
end
