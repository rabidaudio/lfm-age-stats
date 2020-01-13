# frozen_string_literal: true

namespace :data do
  desc 'Load LastFM data from 2010 to 2020 for provided username'
  task :load => [:environment] do |_, _args|
    username = ENV['username'] || (raise StandardError, 'Username is required')
    mb = MusicBrainzService.new
    search = {
      from: Time.local(2010).to_i,
      to: Time.local(2020).to_i,
      user: username,
      extended: 1
    }
    LastFmService.each_track(search) do |track|
      artist = track.artist.name
      album = track.album['#text']
      next unless track.date # this happens for now playing tracks

      listened = Time.zone.at(track.date.uts.to_i)
      release_date = mb.album_release_date(mbid: track.album.mbid, artist: artist, album: album)

      Scrobble.create!(
        track_mbid: track.mbid.presence,
        album_mbid: track.album.mbid.presence,
        artist_mbid: track.artist.mbid.presence,
        release_date: release_date,
        track: track.name,
        artist: artist,
        album: album,
        scrobbled_at: listened,
        username: username
      )
      Rails.logger.info("#{username}: #{track.name} | #{artist} | #{album} on #{listened}")
    end
  end

  task :export => [:environment] do
    Scrobble.all_usernames.each do |username|
      Scrobble.cache_stats!(username)
    end
  end

  task :export_raw => [:environment] do
    File.open('db/scrobbles.json', 'w') do |f|
      Scrobble.find_each do |s|
        f << s.to_json(except: [:id, :created_at, :updated_at])
        f << "\n"
      end
    end
  end

  task :import_raw => [:environment] do
    ActiveRecord::Base.transaction do
      File.open('db/scrobbles.json').lines.each do |l|
        Scrobble.create!(JSON.parse(l.chomp))
      end
    end
  end
end
