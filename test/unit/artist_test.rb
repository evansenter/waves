require "test_helper"

class ArtistTest < ActiveSupport::TestCase
  def setup
    Artist.destroy_all
    @artist = Factory(:artist)
  end
  
  test "presence validations" do
    @artist.name = ""
    assert_invalid_on @artist, :name, "can't be blank"
    
    @artist.mbid = ""
    assert_invalid_on @artist, :mbid, "can't be blank"
  end
  
  test "uniqueness validations" do
    @new_artist = Artist.new(:mbid => @artist.mbid)
    assert_invalid_on @new_artist, :mbid, "has already been taken"
  end
  
  test "similar_to with a new valid similar artist" do
    assert_difference "Similarity.count", 2 do
      assert_difference "Artist.count" do
        @artist.similar_to("The Band", "secret_mbid_code", 1)
      end
    end
    
    similar_artist = @artist.similar_artists.first
    
    assert_equal [@artist],        similar_artist.similar_artists
    assert_equal [similar_artist], @artist.similar_artists
    
    assert_equal 1, similar_artist.similarities.with(@artist).match
    assert_equal 1, @artist.similarities.with(similar_artist).match
  end
  
  test "similar_to with a new invalid similar artist" do
    assert_no_difference "Similarity.count" do
      assert_no_difference "Artist.count" do
        @artist.similar_to("", "", 1)
      end
    end
  end
  
  test "similar_to with an existing artist" do
    similar_artist = Factory(:artist)
    
    assert_difference "Similarity.count", 2 do
      assert_no_difference "Artist.count" do
        @artist.similar_to(similar_artist.name, similar_artist.mbid, 1)
      end
    end
    
    assert_no_difference "Similarity.count" do
      assert_no_difference "Artist.count" do
        @artist.similar_to(similar_artist.name, similar_artist.mbid, 0)
      end
    end
    
    assert_equal [@artist],        similar_artist.similar_artists
    assert_equal [similar_artist], @artist.similar_artists
    
    assert_equal 0, Artist.find(similar_artist.id).similarities.with(@artist).match
    assert_equal 0, Artist.find(@artist.id).similarities.with(similar_artist).match
  end
  
  test "similarities removed on destroy" do
    assert_difference "Similarity.count", 2 do
      assert_difference "Artist.count" do
        @artist.similar_to("The Band", "secret_mbid_code", 1)
      end
    end
    
    similar_artist = @artist.similarities.first.similar_artist
    assert similar_artist.similarities.with(@artist).present?
    
    assert_difference "Similarity.count", -2 do
      @artist.destroy
    end
    
    assert @artist.similarities.reload.empty?
    assert similar_artist.similarities.empty?
  end
  
  test "similarities with something that isn't similar doesn't return an association" do
    assert @artist.similarities.with(Factory(:artist)).blank?
  end
end