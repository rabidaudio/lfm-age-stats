class StatsController < ApplicationController

  def root
    render component: 'Home', prerender: false, props: {
      usernames: Scrobble.all_usernames
    }
  end

  def show
    @all_scrobbles = Scrobble.username(params[:username])
    @scrobbles = @all_scrobbles.valid.with_release_info

    render component: 'Show', prerender: false, props: Scrobble.all_stats(params[:username])
  end

  def index
    @usernames = params[:usernames] || Scrobble.all_usernames

    render component: 'Index', prerender: false, props: {
      data: @usernames.map { |u| Scrobble.all_stats(u) }
    }
  end
end
