import React from 'react'

import Show from '../Show'

import styles from './styles'

const Index = () => {
  const usernames = new URLSearchParams(window.location.search).getAll('usernames[]')
  if (usernames.length === 0) {
    window.location = '/'
  }
  return (
    <div className={styles.container}>
      {usernames.map(username =>
        <div className={styles.show} key={username}><Show username={username} /></div>)}
    </div>
  )
}

export default Index
