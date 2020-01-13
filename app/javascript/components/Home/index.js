import React from 'react'
import PropTypes from 'prop-types'

import Loading from '../Loading'

import styles from './styles'

class Home extends React.Component {
  constructor (props) {
    super(props)
    this.state = { checked: new Set(), usernames: [], loaded: false }
    this.handleCheckboxChange = this.handleCheckboxChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
  }

  componentDidMount () {
    this.loadUsernames()
  }

  async loadUsernames () {
    try {
      const res = await window.fetch('/api/usernames.json')
      const json = await res.json()
      this.setState({ ...this.state, usernames: json, loaded: true })
    } catch (e) {
      console.error(e)
    }
  }

  toggle (username) {
    const checked = this.state.checked
    checked.has(username) ? checked.delete(username) : checked.add(username)
    this.setState({ checked })
  }

  handleCheckboxChange (event) {
    event.preventDefault()
    const checked = this.state.checked
    const username = event.target.name
    event.target.checked ? checked.add(username) : checked.delete(username)
    this.setState({ checked })
  }

  handleSubmit () {
    if (this.state.checked.size === 0) return
    const url = new URL('/stats', window.location.origin)
    this.state.checked.forEach(username => url.searchParams.append('usernames[]', username))
    window.location = url.toString()
  }

  keyFor (username) {
    return `${username}:${this.state.checked.has(username)}`
  }

  render () {
    if (!this.state.loaded) return (<Loading />)
    return (
      <>
        <p>Select some users to compare.</p>
        <ul>
          {this.state.usernames.map(username =>
            <li key={this.keyFor(username)} name={username} className={styles.username}>
              <input
                type='checkbox'
                name={username}
                checked={this.state.checked.has(username)}
                onChange={this.handleCheckboxChange}
              />
              <span onClick={() => this.toggle(username)}>{username}</span>
            </li>
          )}
        </ul>
        <input
          className={styles.submit}
          enabled={this.state.checked.size === 0 ? 'true' : 'false'}
          type='button' onClick={this.handleSubmit} value='Compare'
        />
      </>
    )
  }
}

Home.propTypes = {
  usernames: PropTypes.arrayOf(PropTypes.string)
}

export default Home
