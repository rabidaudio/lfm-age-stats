import React from 'react'
import PropTypes from 'prop-types'

import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip
} from 'recharts'
import colormap from 'colormap'

const DEFAULT_COLORS = colormap()

const AgeHistogram = props => (
  <BarChart
    width={props.width || 500}
    height={props.height || 300}
    data={props.data}
    margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
  >
    <CartesianGrid strokeDasharray='3 3' />
    <XAxis dataKey='months' />
    <YAxis />
    <Tooltip />
    <Bar dataKey='count' fill={DEFAULT_COLORS[0]} />
  </BarChart>
)

AgeHistogram.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape({
    months: PropTypes.int,
    count: PropTypes.int
  }))
}

export default AgeHistogram
