import React from 'react'

import Show from '../Show'

import styles from './styles'

const Index = props => (
  <div className={styles.container}>
    {props.data.map(childProps =>
      <div className={styles.show} key={childProps.username}><Show {...childProps} /></div>)}
  </div>
)

export default Index
