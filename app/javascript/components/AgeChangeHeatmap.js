import React from "react"
import PropTypes from "prop-types"

import { Group } from '@vx/group'
import { scaleLinear, extent } from '@vx/scale'
import { HeatmapCircle, HeatmapRect } from '@vx/heatmap'
import { groupBy, map, reduce, merge, fromPairs, range, get } from 'lodash'

const max = (data, value = d => d) => Math.max(...data.map(value));
const min = (data, value = d => d) => Math.min(...data.map(value));

const AgeChangeHeatmap = props => {
  const data = props.data

  const quarterMin = 2010 * 4 // min(data, d => d.quarter)
  const quarterMax = 2020 * 4 - 1 //max(data, d => d.quarter)
  const bucketMax =  Math.floor(50 * 365.25 / 90) // max(data, d => d.bucket)
  const countMax = max(data, d => d.count)

  const lookupData = fromPairs(map(groupBy(data, d => d.quarter), (qData, q) => 
    [q, fromPairs(qData.map(({ quarter, bucket, count }) => [bucket, count]))]))

  const binData = map(range(quarterMin, quarterMax), q => ({
    bin: q - quarterMin,
    bins: map(range(0, bucketMax), m => ({ bin: m, count: get(lookupData, [q, m], 0) }))
  }))

  const width = props.width || 500
  const height = props.height || 300

  const xScale = scaleLinear({
    range: [0, width],
    domain: [0, quarterMax - quarterMin]
  })
  const yScale = scaleLinear({
    range: [height, 0],
    domain: [0, bucketMax]
  })
  const colorScale = scaleLinear({
    range: ['white', 'red'],
    // range: ["#ffffff", "#000000"],
    // range: ['blue', 'red'],
    domain: [0, countMax]
  })

  const binWidth = width / (quarterMax - quarterMin)
  const binHeight = height / bucketMax

  return (
    <React.Fragment>
      <p>
        The following is a heatmap of how the age of the music you listen to has changed over time.
        The x axis is listen time, quantized to quarter years. The y axis is the age of your music,
        quantized to 90 day chunks, with the bottom being brand new music. The brightness represents
        the quantity of music.
      </p>
      <svg width={width} height={height}>
        <rect x={0} y={0} width={width} height={height} fill="white" />
        <Group top={0} left={0}>
          <HeatmapRect
            data={binData}
            xScale={xScale}
            yScale={yScale}
            gap={0}
            colorScale={colorScale}
            binWidth={binWidth}
            binHeight={binHeight} >
            {heatmap => {
              return heatmap.map(bins => {
                return bins.map(bin => {
                  return <rect
                      key={`heatmap-rect-${bin.row}-${bin.column}`}
                      className="vx-heatmap-rect"
                      width={bin.width}
                      height={bin.height}
                      x={bin.x}
                      y={bin.y}
                      fill={bin.color} />
                })
              })
            }}
          </HeatmapRect>
        </Group>
      </svg>
    </React.Fragment>
  )
}

AgeChangeHeatmap.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape({
    quarter: PropTypes.number,
    bucket: PropTypes.number,
    count: PropTypes.number
  }))
}

export default AgeChangeHeatmap
