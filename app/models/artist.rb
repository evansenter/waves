class Artist < ActiveRecord::Base  
  has_many :similarities, :dependent => :destroy

  validates_presence_of   :name, :mbid
  validates_uniqueness_of :mbid, :allow_blank => true

  class << self
    def retrieve(duration = 1.day, interval = 1.second, display_stats = false)
      Rails.logger.silence do
        start_time = Time.now

        while start_time + duration > Time.now
          if artist = Artist.find_by_queried(false)
            artist.add_similar

            display_stats ? stats(artist.name, (start_time + duration - Time.now) / 1.minute) : print(".")
            sleep interval.to_i
          end
        end
      end
    rescue Exception => error
      retry
    end
  
    def stats(artist_name, time_remaining)
      puts "%.2f%% queried (out of #{Artist.count} artists), appx. %d minutes remaining - added '%s'" % [
        100.0 * Artist.count(:conditions => { :queried => true }) / Artist.count,
        time_remaining,
        artist_name
      ]
    end
  end
  
  def relations
    [
      Relation.set_from(similarities(:include => :similar_artist), :similar_artist),
      Relation.set_from(Similarity.find_all_by_similar_artist_id(id, :include => :artist), :artist)
    ].inject(&:+)
  end
  
  def add_similar
    if (similar_artists = Last.similar_artists_for(name)).present?
      similar_artists.each do |similar_artist|
        similar_to(similar_artist[:name], similar_artist[:mbid], similar_artist[:score])
      end
    end
  ensure
    update_attributes(:queried => true)
  end
  
  def similar_to(name, mbid, score)
    similarities.create({
      :score             => score,
      :similar_artist_id => Artist.find_or_create_by_mbid({
        :name => name,
        :mbid => mbid
      }).id
    })
  end
end