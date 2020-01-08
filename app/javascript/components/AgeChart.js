import React from "react"
import PropTypes from "prop-types"

// import {
//   BarChart, Bar, Cell, XAxis, YAxis, CartesianGrid, Tooltip, Legend,
// } from "recharts"
import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend
} from "recharts"
// import { getColorFromString, getColorFromNumber } from "hash-color-material"
import chromahash from "chromahash"

      // barCategoryGap="0"
      // barGap="0"
      // barSize="20"

const AgeChart = props => (
  <LineChart
      width={props.width || 500}
      height={props.height || 300}
      data={props.data}
      margin={{top: 5, right: 30, left: 20, bottom: 5}}>
    <CartesianGrid strokeDasharray="3 3" />
    <XAxis dataKey="year" />
    <YAxis />
    <Tooltip />
    <Legend />
    { props.usernames.map((username, i) =>
       <Line dataKey={username} type="natural" dot={false} stroke={`#${chromahash(username)}`} strokeWidth="3" key={username} />)
    }
  </LineChart>
)
// fill={getColorFromString(username)}

AgeChart.propTypes = {
  // [{ year: string, `username`: integer })]
  data: PropTypes.arrayOf(PropTypes.object),
  usernames: PropTypes.arrayOf(PropTypes.string)
}

export default AgeChart
