class Scrobble < ApplicationRecord
  scope :valid, ->{
    where.not(scrobbled_at: nil).where('release_date <= scrobbled_at')
      .where(scrobbled_at: Date.new(2010)..Date.new(2020))
  }
  scope :with_release_info, ->{ where.not(release_date: nil) }
  scope :username, ->(username) { where(username: username) }
  scope :artist, ->(artist) { where(artist: artist) }
  scope :album, ->(album) { where(album: album) }
  scope :early_fan, -> {
    where("floor(extract(epoch from scrobbled_at) - extract(epoch from release_date))::bigint <= ?", 7.days)
  }

  scope :aggregate_by_user_and_relese_year, ->{
    group('extract(year from release_date)::varchar', :username).count
  }
  scope :aggregate_by_album, ->{ group(:artist, :album, :release_date).order(release_date: :desc).count }

  def self.all_usernames
    group(:username).order(:minimum_id).minimum(:id).keys
  end

  def age
    return nil unless scrobbled_at && release_date

    (scrobbled_at - release_date.at_midnight).to_i
  end

  def release_year
    release_date.year
  end

  def quarter
    (scrobbled_at.year * 4) + ((scrobbled_at.month - 1) / 3)
  end

  def self.year_stats
    Stats.new(all.map(&:release_year).compact)
  end

  def self.age_stats
    Stats.new(all.map(&:age).compact, mode_size: 1.week)
  end

  def self.early_fan_albums
    all.early_fan.aggregate_by_album.map do |(artist, album, release_date), count|
      { artist: artist, album: album, release_date: release_date, count: count }
    end
  end

  def self.age_histogram
    age_stats.histogram(bucket_size: 30.days).map do |months, count|
      { months: months, count: count }
    end
  end

  def self.age_change
    all.group_by(&:quarter).sort_by(&:first).map do |quarter, scrobbles|
      age_years = scrobbles.map(&:age).compact.map { |age| age / 1.year.to_f }
      Stats.new(age_years).all.merge(quarter: quarter)
    end
  end

  def self.age_change_heatmap
    all.group_by(&:quarter).sort_by(&:first).flat_map do |quarter, scrobbles|
      Stats.new(scrobbles.map(&:age).compact).histogram(bucket_size: 90.days).map do |bucket, count|
        { quarter: quarter, bucket: bucket, count: count }
      end
    end
  end

  def self.year_chart_data
    query = aggregate_by_user_and_relese_year
    return [] if query.empty?
    years_with_data = query.keys.map(&:first)
    all_years = (years_with_data.min..years_with_data.max).to_a
    usernames = query.keys.map(&:last).uniq
    all_years.map do |y|
      usernames.reduce({ year: y.to_i }) do |d, u|
        d.merge(u => query[[y, u]] || 0)
      end
    end
  end

  def self.reload_all_stats!
    all_usernames.each { |u| Rails.cache.delete("all_stats?username=#{u}") }
  end

  def self.all_stats(username)
    Rails.cache.fetch("all_stats?username=#{username}") do
      scrobbles = username(username).valid.with_release_info
      {
        username: username,
        scrobble_count: username(username).count,
        scrobble_with_release_count: scrobbles.count,
        year_chart: scrobbles.year_chart_data,
        year_stats: scrobbles.year_stats.all,
        age_stats: scrobbles.age_stats.all,
        ages: scrobbles.age_histogram,
        early_fan_albums: scrobbles.early_fan.early_fan_albums,
        age_change: scrobbles.age_change,
        age_change_heatmap: scrobbles.age_change_heatmap
      }
    end
  end
end
