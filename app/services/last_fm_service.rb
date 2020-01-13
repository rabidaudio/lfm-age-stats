# frozen_string_literal: true

# Repository for getting info from Last.FM api
module LastFmService
  extend self

  # an API error from Last.FM
  class Error < StandardError
    attr_reader :res
    def initialize(res)
      super(res['message'])
      @res = res
    end
  end

  def each_track(params, &block)
    each_item(LastFM::User, :get_recent_tracks, ['recenttracks', '@attr'], params) do |page|
      page.to_hashugar.recenttracks.track.each(&block)
    end
  end

  def album_info(params)
    request(LastFM::Album, :get_info, params).to_hashugar.album
  rescue Error => e
    return if e.message.include?('Album not found')

    raise e
  end

  protected

  def request(receiver, method, args)
    key = key(receiver, method, args)
    Rails.cache.fetch(key) do
      throttle do
        Rails.logger.info("REQUEST #{key}")
        receiver.send(method, args).tap do |res|
          # Rails.cache.delete(key(receiver, method, args))
          raise Error, res if res['error']
        end
      end
    end
  end

  def key(receiver, method, args)
    encode_key("#{receiver}.#{method}", args)
  end

  def encode_key(name, args = {})
    args.empty? ? name : "#{name}?#{URI.encode_www_form(args.sort.to_h)}"
  end

  def throttle
    @last_request ||= Time.zone.at(0)
    age = Time.zone.now - @last_request
    sleep(throttle_time - age) if age < throttle_time
    yield.tap { @last_request = Time.zone.now }
  end

  def each_item(receiver, method, attr_path, args)
    page = 1
    loop do
      data = request(receiver, method, args.merge(limit: 200, page: page))
      yield data
      total_pages = data.dig(*attr_path, 'totalPages').to_i
      break if page == total_pages

      page += 1
    end
  end
end
