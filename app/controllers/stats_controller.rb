class StatsController < ApplicationController

  INDEX_USER_LIMIT = 5

  def show
    @scrobbles = Scrobble.username(params[:username])

    render component: 'Stats', prerender: false, props: {
      username: params[:username],
      scrobble_count: @scrobbles.count,
      scrobble_with_release_count: @scrobbles.with_release_info.count,
      year_chart: @scrobbles.year_chart_data([params[:username]]),
      age_stats: @scrobbles.age_stats.all_stats
    }
  end

  def index
    @usernames = index_usernames

    render component: 'AgeChart', prerender: false, props: {
      usernames: @usernames,
      data: Scrobble.year_chart_data(@usernames),
      width: 1000,
      height: 600
    }
  end

  def index_usernames
    params.permit(usernames: [])[:usernames].try(:take, INDEX_USER_LIMIT) ||
      Scrobble.distinct.limit(INDEX_USER_LIMIT).pluck(:username)
  end
end
