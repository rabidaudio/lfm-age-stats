# frozen_string_literal: true

namespace :static do
  # ActionDispatch::Integration::Session.new(Rails.application).get('/')
  # send(:_mock_session).last_response
  class Generator
    include Rails.application.routes.url_helpers
    attr_reader :host

    def initialize(host: 'http://localhost:3000')
      @host = host
    end

    def generate!(output: Rails.root.join('docs'))
      @output = output
      FileUtils.cp_r(Rails.root.join('public/packs'), @output.join('packs'))
      ui_paths.each { |p| save!(p, json: false) }
      api_paths.each { |p| save!(p, json: true) }
    end

    protected

    def save!(path, json: false)
      filepath = json ? "#{path}.json" : "#{path}/index.html"
      filepath.sub!(/^\/+/, '')
      filepath = @output.join(filepath)
      FileUtils.mkdir_p(filepath.dirname)
      Rails.logger.info("saving #{path} to #{filepath}")
      res = Net::HTTP.get_response(URI("#{host}/#{path}"))
      raise StandardError, "Request failed: #{res}" if res.code != '200'

      File.open(filepath, 'w') { |f| f << res.body.force_encoding('utf-8') }
    rescue Errno::ECONNREFUSED
      raise StandardError, 'Connection refused. Do you have the server running in production mode?'
    end

    def ui_paths
      [root_path, stats_path]
    end

    def api_paths
      [api_usernames_path] + Scrobble.all_usernames.map { |username| api_stats_path(username) }
    end
  end

  task :generate => [:environment] do
    Generator.new.generate!
  end
end
