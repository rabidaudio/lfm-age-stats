class Scrobble < ApplicationRecord
  scope :username, ->(username) { where(username: username) }
  scope :with_release_info, ->{ where.not(release_date: nil) }
  scope :release_year, ->(year) { with_release_info.where(release_date: Date.new(year)..Date.new(year + 1)) }
  scope :scrobble_year, ->(year) { where(scrobbled_at: Date.new(year)..Date.new(year + 1)) }

  def age
    return nil unless scrobbled_at && release_date

    (scrobbled_at.to_date - release_date).to_i
  end
end
