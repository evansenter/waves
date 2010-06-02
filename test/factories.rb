Factory.define(:artist) do |factory|
  factory.sequence(:name) { |count| "name_#{count}" }
  factory.sequence(:mbid) { |count| "mbid_#{count}" }
end

Factory.define(:similarity) do |factory|
  factory.association(:artist)
  factory.association(:similar_artist, :factory => :artist)
  factory.score(1)
end