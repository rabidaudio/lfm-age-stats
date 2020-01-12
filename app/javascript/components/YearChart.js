import React from "react"
import PropTypes from "prop-types"

import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend
} from "recharts"
import colormap from "colormap"

const YearChart = props => {
  const colors = colormap({
    colormap: 'phase',
    nshades: Math.max(props.usernames.length, 9)
  })

  return (
    <LineChart width={props.width || 500}
                height={props.height || 300}
                data={props.data}
                margin={{top: 5, right: 30, left: 20, bottom: 5}}>
      <CartesianGrid strokeDasharray="3 3" />
      <XAxis dataKey="year" />
      <YAxis />
      <Tooltip />
      <Legend />
      { props.usernames.map((username, i) =>
         <Line dataKey={username}
               type="linear"
               dot={false}
               stroke={colors[i]}
               strokeWidth="3"
               key={username} />)
      }
    </LineChart>
  )
}

YearChart.propTypes = {
  // [{ year: string, `username`: integer })]
  data: PropTypes.arrayOf(PropTypes.object),
  usernames: PropTypes.arrayOf(PropTypes.string)
}

export default YearChart
