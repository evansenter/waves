class Similarity < ActiveRecord::Base
  belongs_to :artist
  belongs_to :similar_artist, :class_name => "Artist"
  
  validates_presence_of     :artist_id, :similar_artist_id
  validates_uniqueness_of   :similar_artist_id, :scope => :artist_id
  validates_numericality_of :match, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1
end
