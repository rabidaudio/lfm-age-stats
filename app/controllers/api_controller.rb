# frozen_string_literal: true

# Statistics about music age
class ApiController < ActionController::API
  def usernames
    render json: Scrobble.all_usernames
  end

  def stats
    render json: Scrobble.all_stats(params[:username])
  end
end
