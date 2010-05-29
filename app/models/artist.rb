class Artist < ActiveRecord::Base
  has_many :similarities, :dependent => :destroy do
    def with(artist)
      first(:conditions => { :similar_artist_id => artist })
    end
  end
  
  has_many :similar_artists, :through => :similarities

  validates_presence_of   :name, :mbid
  validates_uniqueness_of :mbid, :allow_blank => true
  
  before_destroy do |record|
    Similarity.destroy_all(:similar_artist_id => record)
  end
  
  def similar_to(name, mbid, match, create_secondary_association = true)
    similarity = similarities.find_or_create_by_similar_artist_id({
      :match             => match,
      :similar_artist_id => Artist.find_or_create_by_mbid({
        :name => name,
        :mbid => mbid
      }).id
    })
    
    if similarity.id.present?
      similarity.update_attributes(:match => match)
      similarity.similar_artist.similar_to(self.name, self.mbid, match, false) if create_secondary_association
    end
  end
end
