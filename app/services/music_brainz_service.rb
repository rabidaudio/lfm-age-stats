module MusicBrainzService
  extend self

  # def initialize
  #   @cache = Rails.cache # Cache.new(file_path: 'cache/musicbrainz')
  # end

  def album_info(mbid:, artist:, album:)
    Rails.cache.fetch("album_info?mbid=#{mbid}&artist=#{artist}&album=#{album}") do
      load_album_info(mbid: mbid, artist: artist, album: album)
    end
  end

  private

  def load_album_info(mbid:, artist:, album:)
    Rails.logger.info("REQUEST album_info?mbid=#{mbid}&artist=#{artist}&album=#{album}")
    if mbid.present?
      release = MusicBrainz::Release.find(mbid)
      return release if release.present? && release.id.present?
    end

    results = MusicBrainz::ReleaseGroup.search(artist, album)
    return if results.empty? || results.first[:score] < 90
    group = MusicBrainz::ReleaseGroup.find(results.first[:mbid])
    releases = group.releases rescue nil
    return unless releases
    releases.first
  end
end
