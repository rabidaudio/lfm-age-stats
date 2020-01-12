class Stats
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def histogram(bucket_size:)
    bucket(bucket_size).map { |v, items| [v, items.count] }
  end

  def split_by(bucket_size:)
    bucket(bucket_size).map { |bucket, items| [bucket, Stats.new(items)] }
  end

  def mean
    @mean ||= sum.to_f / count.to_f
  end

  def median
    @median ||= data[count / 2]
  end

  def mode
    return nil if count.zero?

    @mode ||= data.group_by(&:itself).max_by { |k, v| v.count }.first
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

  def upper_bound
    mean + std_dev
  end

  def lower_bound
    mean - std_dev
  end

  def all
    {
      sum: sum,
      count: count,
      min: min,
      max: max,
      mean: mean,
      median: median,
      mode: mode,
      std_dev: std_dev,
      upper_bound: upper_bound,
      lower_bound: lower_bound
    }
  end

  private

  def bucket(bucket_size)
    data.group_by { |v| (v - min) / bucket_size }.sort_by(&:first)
  end

  def sum_squared_diff
    data.map { |v| (v - mean) ** 2 }.sum.to_f
  end
end
