import React from "react"
import PropTypes from "prop-types"

import styles from "./styles.module.scss"

function roundPercent (num, denom) {
  return Math.round(num / denom * 100 * 100) / 100
}

const NoneFound = () => (<div>No data stored for this user.</div>)


/*<div className={styles.metric}>
    <div className={styles.metric.name}>{props.name}</div>
    <div className={styles.metric.value}>{props.value}</div>
  </div>*/
const Metric = props => (
   <div>
    <div>{props.name}</div>
    <div>{props.value}</div>
  </div>
)
Metric.propTypes = {
  name: PropTypes.string,
  value: PropTypes.string
}

const Stats = props => (
  <div>
    <h1><a href="https://www.last.fm/user/{props.username}">{props.username}</a></h1>
    { props.scrobble_count == 0
      ? <NoneFound />
      : <div>
          <Metric name="Scrobbles" value={props.scrobble_count} />
          <Metric name="With release info" value={roundPercent(props.scrobble_with_release_count, props.scrobble_count)} />
        </div>
    }
  </div>
)

Stats.propTypes = {
  username: PropTypes.string,
  scrobble_count: PropTypes.number,
  scrobble_with_release_count: PropTypes.number
}

export default Stats
