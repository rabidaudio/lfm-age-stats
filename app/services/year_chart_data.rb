
class YearChartData
  def initialize(usernames)
    @usernames = usernames
  end

  def data(scope = Scrobble.all)
    @scope = scope
    years.map { |y, data| data.merge(year: y) }
  end

  private

  def query
    @scope.aggregate_by_user_and_relese_year(@usernames)
  end

  def points
    query.map { |(y, u), c| [y, u, c] }
  end

  def years
    points.reduce({}) do |data, (y, u, c)|
      data.merge(y => (data[y] || {}).merge(u => c))
    end
  end
end
