import React from "react"
import PropTypes from "prop-types"

import Show from "../Show"

import styles from "./styles"

const Index = props => (
  <div className={styles.container}>
    { props.data.map(childProps => 
        <Show className={styles.show} key={childProps.username} {...childProps} />)
    }
  </div>
)

export default Index
