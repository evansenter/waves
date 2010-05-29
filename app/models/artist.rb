class Artist < ActiveRecord::Base
  has_many :similarities do
    def with(artist)
      first(:conditions => { :similar_artist_id => artist })
    end
  end
  
  has_many :similar_artists, :through => :similarities

  validates_presence_of   :name, :mbid
  validates_uniqueness_of :mbid
  
  before_destroy do |record|
    Similarity.destroy_all(:similar_artist => record)
  end
  
  def similar_to(name, mbid, match)
    returning(similarities.find_or_create_by_similar_artist_id({
      :match             => match,
      :similar_artist_id => Artist.find_or_create_by_mbid({
        :name => name,
        :mbid => mbid
      }).id
    })) do |similarity|
      similarity.update_attributes(:match => match)
      Similarity.create(:artist => similarity.similar_artist, :similar_artist => similarity.artist, :match => similarity.match)
    end
  end
end
