class RemoveIndicesThatArentUsed < ActiveRecord::Migration
  def self.up
    remove_index :artists, :name
    remove_index :similarities, :score
  end

  def self.down
    add_index :artists, :name
    add_index :similarities, :score
  end
end
