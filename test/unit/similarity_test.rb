require "test_helper"

class SimilarityTest < ActiveSupport::TestCase
  def setup
    Similarity.destroy_all
    @similarity = Factory(:similarity)
  end
  
  test "presence validations" do
    @similarity.artist = nil
    assert_invalid_on @similarity, :artist_id, "can't be blank"
    
    @similarity.similar_artist = nil
    assert_invalid_on @similarity, :similar_artist_id, "can't be blank"
    
    @similarity.match = nil
    assert_invalid_on @similarity, :match, "can't be blank"
  end
  
  test "uniqueness validations" do
    new_similarity = Similarity.new(:artist => @similarity.artist, :similar_artist => @similarity.similar_artist, :match => 1)
    assert_invalid_on new_similarity, :similar_artist_id, "has already been taken"
    
    new_similarity = Similarity.new(:artist => Factory(:artist), :similar_artist => @similarity.similar_artist, :match => 1)
    assert new_similarity.valid?
    
    new_similarity = Similarity.new(:artist => @similarity.artist, :similar_artist => Factory(:artist), :match => 1)
    assert new_similarity.valid?
  end
  
  test "numericality validations" do
    @similarity.match = 0
    assert @similarity.valid?
    
    @similarity.match = 0.5
    assert @similarity.valid?
    
    @similarity.match = 1
    assert @similarity.valid?
    
    @similarity.match = -1
    assert_invalid_on @similarity, :match, "must be greater than or equal to 0"
    
    @similarity.match = 9000
    assert_invalid_on @similarity, :match, "must be less than or equal to 1"
    
    @similarity.match = "Dude, these bands are totally similar"
    assert_invalid_on @similarity, :match, "is not a number"
  end
end
