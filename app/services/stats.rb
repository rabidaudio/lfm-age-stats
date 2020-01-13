# frozen_string_literal: true

# Helper class for extracting statistics from an array
# of numbers
class Stats
  attr_reader :data

  def initialize(data, mode_size: 1)
    @data = data
    @mode_size = mode_size
  end

  def histogram(bucket_size:)
    bucket(bucket_size).map { |v, items| [v, items.count] }
  end

  def mean
    @mean ||= sum / count.to_f
  end

  def median
    @median ||= data.sort[count / 2]
  end

  def mode
    return nil if count.zero?

    @mode ||= Stats.new(aggregated_mode_data).mean
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

  def aggregated_mode_data
    data.group_by { |d| d / @mode_size }.max_by { |_k, v| v.count }.last
  end

  def bucket(bucket_size)
    data.group_by { |v| (v - min) / bucket_size }.sort_by(&:first)
  end

  def sum_squared_diff
    data.map { |v| (v - mean)**2 }.sum.to_f
  end
end
