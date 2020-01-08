class Stats
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def mean
    @mean ||= sum.to_f / count.to_f
  end

  def median
    @median ||= data[count / 2]
  end

  def mode
    @mode ||= data.group_by(&:itself).map { |_,v| v.count }.max
  end

  def sum
    @sum ||= data.sum
  end

  def count
    @count ||= data.count
  end

  def min
    @min ||= data.min
  end

  def max
    @max ||= data.max
  end

  def std_dev
    @std_dev ||= Math.sqrt(sum_squared_diff / (count - 1).to_f)
  end

  def all_stats
    {
      sum: sum,
      count: count,
      min: min,
      max: max,
      mean: mean,
      median: median,
      mode: mode,
      std_dev: std_dev
    }
  end

  private

  def sum_squared_diff
    data.map { |v| (v - mean) ** 2 }.sum.to_f
  end
end
