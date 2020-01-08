
namespace :data do
  desc "Load LastFM data from 2010 to 2020 for provided username"
  task :load => [:environment] do |_, args|
    username = ENV['username'] || (raise StandardError, 'Username is required')
    LastFmService.each_track(user: username, extended: 1, from: Time.local(2010).to_i, to: Time.local(2020).to_i) do |track|
      artist = track.artist.name
      album = track.album['#text']
      next unless track.date # this happens for now playing tracks
      listened = Time.at(track.date.uts.to_i)
      album_data = MusicBrainzService.album_info(mbid: track.album.mbid, artist: artist, album: album)

      Scrobble.create_with(
        track_mbid: track.mbid.presence,
        album_mbid: track.album.mbid.presence,
        artist_mbid: track.artist.mbid.presence,
        release_date: album_data.try(:date)
      ).find_or_create_by!(
        track: track.name,
        artist: artist,
        album: album,
        scrobbled_at: listened,
        username: username
      )
      Rails.logger.info("#{username}: #{track.name} | #{artist} | #{album} on #{listened}")
    end
  end
end
