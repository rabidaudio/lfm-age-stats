import React from "react"
import PropTypes from "prop-types"

import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend
} from "recharts"
import colormap from "colormap"

const DEFAULT_COLORS = colormap({ nshades: 7 })

function quarterName (quarter) {
  var year = Math.floor(quarter / 4)
  var q = (quarter % 4) + 1
  return `${year} Q${q}`
}

const AgeChange = props => {
  props.data.forEach(k => {
    k.quarter = quarterName(k.quarter)
  })

  return (
    <LineChart width={props.width || 500}
                height={props.height || 300}
                data={props.data}
                margin={{top: 5, right: 30, left: 20, bottom: 5}}>
      <CartesianGrid strokeDasharray="3 3" />
      <XAxis dataKey="quarter" />
      <YAxis />
      <Tooltip />
      <Line dot={false} dataKey="mean" stroke={DEFAULT_COLORS[0]} />
      <Line dot={false} dataKey="upper_bound" stroke={DEFAULT_COLORS[1]} />
      <Line dot={false} dataKey="lower_bound" stroke={DEFAULT_COLORS[2]} />
      <Line dot={false} dataKey="min" stroke={DEFAULT_COLORS[3]} />
      <Line dot={false} dataKey="max" stroke={DEFAULT_COLORS[4]} />
      <Line dot={false} dataKey="median" stroke={DEFAULT_COLORS[5]} />
    </LineChart>
  )
}

AgeChange.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape({
    quarter: PropTypes.number,
    mean: PropTypes.number,
    median: PropTypes.number,
    mode: PropTypes.number,
    min: PropTypes.number,
    max: PropTypes.number,
    upperBound: PropTypes.number,
    lowerBound: PropTypes.number
  }))
}

export default AgeChange
