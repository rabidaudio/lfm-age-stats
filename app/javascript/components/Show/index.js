import React from "react"
import PropTypes from "prop-types"

import { mapValues, sample } from "lodash"
import { Duration }  from "luxon"

import YearChart from "../YearChart"
import AgeHistogram from "../AgeHistogram"
import AgeChange from "../AgeChange"
import Metric from "../Metric"
import AgeChangeHeatmap from "../AgeChangeHeatmap"

import styles from "./styles"

function roundToDecimal (value, decimal = 2) {
  return Math.round(value * Math.pow(10, decimal)) / Math.pow(10, decimal)
}

function roundPercent (num, denom) {
  return roundToDecimal(num / denom * 100)
}

function formatInterval (seconds) {
  const duration = Duration.fromObject({ years: 0, days: 0, seconds: seconds }).normalize()
  window.Duration = Duration
  if (Math.floor(duration.as('days')) === 0) return `${duration.seconds} seconds`
  return ['years', 'days']
    .filter(k => duration[k] > 0)
    .map(k => `${Math.floor(duration[k])} ${k}`)
    .join(' ')
}

const NoneFound = () => (<div>No data stored for this user.</div>)

const Header = props => (
  <div className={styles.header}>
    <Metric name="Scrobbles" value={props.scrobble_count} />
    <Metric name="With release info"
            value={`${roundPercent(props.scrobble_with_release_count, props.scrobble_count)}%`} />
  </div>
)

const AGE_STATS_MAP = {
  min: 'Minimum',
  mean: 'Mean',
  median: 'Median',
  mode: 'Mode',
  std_dev: 'Standard Deviation',
  max: 'Maximum'
}
const AgeStatistics = props => (
  <table>
    <tbody>
      { Object.keys(AGE_STATS_MAP).filter(key => (props.skip || []).indexOf(key) === -1).map(key =>
          <tr key={key}><td>{AGE_STATS_MAP[key]}</td><td>{props[key]}</td></tr>
        )
      }
    </tbody>
  </table>
)
AgeStatistics.propTypes = mapValues(AGE_STATS_MAP, () => PropTypes.oneOfType([PropTypes.number, PropTypes.string]))

const EarlyFan = props => (
  <React.Fragment>
    <h3>Early Fan</h3>
    <p>These are the albums you listened to the first week it came out</p>
    <table>
      <thead>
        <tr>
          <th>Released</th>
          <th>Artist</th>
          <th>Album</th>
          <th>Plays</th>
        </tr>
      </thead>
      <tbody>
        { props.data.map(stat =>
          <tr key={JSON.stringify(stat)}>
            <td>{stat.release_date}</td>
            <td>{stat.artist}</td>
            <td>{stat.album}</td>
            <td>{stat.count}</td>
          </tr>)
        }
      </tbody>
    </table>
  </React.Fragment>
)

const Show = props => (
  <div>
    <h1><a href={`https://www.last.fm/user/${props.username}`}>{props.username}</a></h1>
    { props.scrobble_count == 0
      ? <NoneFound />
      : <React.Fragment>
          <Header {...props} />
          <h3>Years</h3>
          <YearChart data={props.year_chart} usernames={[props.username]} />
          <AgeStatistics
            {...mapValues(props.year_stats, (value, key) => roundToDecimal(value, key == 'std_dev' ? 2 : 0))} />
          <h3>Age - Overall</h3>
          <p>Age here refers to how old the music you listened to was when you listened to it.</p>
          <AgeStatistics {...mapValues(props.age_stats, (value) => formatInterval(value))} />
          <AgeHistogram data={props.ages} />
          <AgeChange data={props.age_change} />
          <AgeChangeHeatmap data={props.age_change_heatmap} />
          <EarlyFan data={props.early_fan_albums} />
        </React.Fragment>
    }
  </div>
)

// Show.propTypes = {
//   username: PropTypes.string,
//   scrobble_count: PropTypes.number,
//   scrobble_with_release_count: PropTypes.number,
//   year_chart: YearChart.propTypes,
//   year_stats: AgeStatistics.propTypes,
//   age_stats: AgeStatistics.propTypes,
//   ages: AgeHistogram.propTypes,
//   early_fan_albums: EarlyFan.propTypes,
//   age_change: AgeChange.propTypes
// }

export default Show
