class Relation
  attr_reader :artist
  attr_accessor :score
  
  def initialize(artist, score)
    @artist = artist
    @score  = score
  end
  
  class << self
    def set_from(similarities, reference)
      similarities.map { |similarity| new(similarity.send(reference), similarity.score) }
    end
    
    def between(*artists)
      artists.map(&:relations).inject do |common_matches, artist_relations|
        common_matches.select(&included_in(artist_relations)).map(&combine_scores(artist_relations))
      end.map(&calculate_score(artists.size)).sort { |a, b| b.score <=> a.score }
    end
    
    def included_in(artist_relations)
      lambda do |relation|
        artist_relations.find { |possible_match| relation.artist == possible_match.artist }
      end
    end
    
    def combine_scores(artist_relations)
      lambda do |relation|
        returning(relation) do
          relation.score += artist_relations.find { |possible_match| relation.artist == possible_match.artist }.score
        end
      end
    end
    
    def calculate_score(divisor)
      lambda do |relation|
        returning(relation) { relation.score /= divisor }
      end
    end
  end
end