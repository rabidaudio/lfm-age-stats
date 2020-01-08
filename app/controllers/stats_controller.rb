class StatsController < ApplicationController
  def show
    @scrobbles = Scrobble.username(params[:username])
    render component: 'Stats', props: { 
      username: params[:username],
      scrobble_count: @scrobbles.count,
      scrobble_with_release_count: @scrobbles.with_release_info.count
    }
  end
end
