class Scrobble < ApplicationRecord
  scope :username, ->(username) { where(username: username) }
  scope :with_release_info, ->{ where.not(release_date: nil) }
  scope :release_year, ->(year) { with_release_info.where(release_date: Date.new(year)..Date.new(year + 1)) }
  scope :scrobble_year, ->(year) { where(scrobbled_at: Date.new(year)..Date.new(year + 1)) }

  # scope :aggregate_by_relese_year, ->{ with_release_info.group('strftime(\'%Y\', release_date)').count }
  scope :aggregate_by_user_and_relese_year, ->(usernames) { 
    username(usernames).with_release_info.group('strftime(\'%Y\', release_date)', :username).count
  }

  def self.age_stats
    Stats.new(all.map(&:age).compact)
  end

  def age
    return nil unless scrobbled_at && release_date

    (scrobbled_at.to_date - release_date).to_i / 365.25
  end

  def self.year_chart_data(usernames)
    YearChartData.new(usernames).data(self)
  end
end
