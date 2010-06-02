module Last
  class << self
    def similar_artists_for(name)
      get_similar_artists_for(name).css("similarartists artist").select do |artist|
        extract(:mbid, artist).present?
      end.map do |artist|
        {
          :name  => extract(:name,  artist),
          :mbid  => extract(:mbid,  artist),
          :score => extract(:match, artist)
        }
      end
    end
    
    private
    
    def get_similar_artists_for(name)
      Nokogiri::XML(open(similar_artist_url(name)))
    end
    
    def similar_artist_url(name)
      "http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar&artist=#{URI.encode(name)}&api_key=#{LastApi::KEY}"
    end
    
    def extract(attribute, container)
      container.css("#{attribute}").first.content
    end
  end
end