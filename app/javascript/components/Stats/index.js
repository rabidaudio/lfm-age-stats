import React from "react"
import PropTypes from "prop-types"

import styles from "./styles.module.scss"

import AgeChart from "../AgeChart"

function roundPercent (num, denom) {
  return Math.round(num / denom * 100 * 100) / 100
}

const NoneFound = () => (<div>No data stored for this user.</div>)

const Metric = props => (
  <div className={styles.metric}>
    <div className={styles.name}>{props.name}</div>
    <div className={styles.value}><div>{props.value}</div></div>
  </div>
)
Metric.propTypes = {
  name: PropTypes.string,
  value: PropTypes.oneOfType([PropTypes.string, PropTypes.number])
}

const Header = props => (
  <div className={styles.header}>
    <Metric name="Scrobbles" value={props.scrobble_count} />
    <Metric name="With release info" value={`${roundPercent(props.scrobble_with_release_count, props.scrobble_count)}%`} />
  </div>
)

const Stats = props => (
  <div>
    <h1><a href={`https://www.last.fm/user/${props.username}`}>{props.username}</a></h1>
    { props.scrobble_count == 0
      ? <NoneFound />
      : <React.Fragment>
          <Header {...props} />
          <AgeChart data={props.year_chart} usernames={[props.username]} />
        </React.Fragment>

          
        
    }
  </div>
)

Stats.propTypes = {
  username: PropTypes.string,
  scrobble_count: PropTypes.number,
  scrobble_with_release_count: PropTypes.number
}

export default Stats
