class CreateSimilarities < ActiveRecord::Migration
  def self.up
    create_table :similarities do |table|
      table.belongs_to :artist
      table.belongs_to :similar_artist
      table.decimal    :score, :precision => 10, :scale => 9
      table.timestamps
    end
    
    add_index :similarities, :artist_id
    add_index :similarities, :similar_artist_id
    add_index :similarities, :score
  end

  def self.down
    drop_table :similarities
  end
end
