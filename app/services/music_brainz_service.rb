class MusicBrainzService
  include CacheMethods

  def album_release_date(mbid:, artist:, album:)
    results = search_release_groups(artist, album)
    return if results.empty?
    results.each do |result|
      next if result[:score] < 90
      group = find_release_group(results.first[:mbid])
      next if group.first_release_date.future?
      return group.first_release_date
    end
    return nil
  end

  private

  cache :search_release_groups
  def search_release_groups(artist, album)
    Rails.logger.info("REQUEST ReleaseGroup?artist=#{artist}&album=#{album}")
    MusicBrainz::ReleaseGroup.search(artist, album)
  end

  cache :find_release_group
  def find_release_group(mbid)
    Rails.logger.info("REQUEST ReleaseGroup?mbid=#{mbid}")
    MusicBrainz::ReleaseGroup.find(mbid)
  end
end
