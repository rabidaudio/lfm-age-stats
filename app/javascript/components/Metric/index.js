import React from "react"
import PropTypes from "prop-types"

import styles from "./styles"

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

export default Metric
