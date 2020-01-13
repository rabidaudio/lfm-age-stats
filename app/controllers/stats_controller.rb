# frozen_string_literal: true

# Statistics about music age
class StatsController < ApplicationController
  def root
    render component: 'Home', prerender: false
  end

  # def show
  #   render component: 'Show', prerender: false
  # end

  def index
    render component: 'Index', prerender: false
  end
end
