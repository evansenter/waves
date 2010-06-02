class Artist < ActiveRecord::Base  
  has_many :similarities, :dependent => :destroy do
    def with(artist)
      first(:conditions => { :similar_artist_id => artist })
    end
    
    def over(match)
      all(:conditions => ["match >= ?", match])
    end
  end
  
  has_many :similar_artists, :through => :similarities

  validates_presence_of   :name, :mbid
  validates_uniqueness_of :mbid, :allow_blank => true
  
  before_destroy do |record|
    Similarity.destroy_all(:similar_artist_id => record)
  end
  
  def self.retrieve(duration = 2.hours, interval = 2.5.seconds, display_stats = true)
    start_time = Time.now
    
    while start_time + duration > Time.now
      if artist = Artist.find_by_queried(false)
        add_similar_to(artist.name, artist.mbid)
        
        display_stats ? stats(artist.name, (start_time + duration - Time.now) / 1.minute) : print(".")
        sleep interval.to_i
      end
    end
  end
  
  def self.stats(artist_name, time_remaining)
    puts "%.2f%% queried (out of #{Artist.count} artists), appx. %d minutes remaining - added '%s'" % [
      100.0 * Artist.find_all_by_queried(true).count / Artist.count,
      time_remaining,
      artist_name
    ]
  end
  
  def self.add_similar_to(name, mbid)
    artist = find_or_create_by_mbid({
      :name => name,
      :mbid => mbid
    })
    
    if (similar_artists = Last.similar_artists_for(artist.name)).present?
      similar_artists.each do |similar_artist|
        artist.similar_to(similar_artist[:name], similar_artist[:mbid], similar_artist[:match])
      end
    end
  ensure
    artist.update_attributes(:queried => true)
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
