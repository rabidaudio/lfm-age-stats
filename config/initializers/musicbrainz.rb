MusicBrainz.configure do |c|
  c.app_name = "MusicAge"
  c.app_version = "0.0.1"
  c.contact = "charles@rabidaudio.com"

  c.cache_path = "cache/musicbrainz"
  c.perform_caching = false

  c.query_interval = 1.2 # seconds
  c.tries_limit = 2
end
