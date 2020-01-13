import React from "react"
import PropTypes from "prop-types"

import styles from "./styles"

class Home extends React.Component {
  constructor(props) {
    super(props)
    this.state = { checked: new Set() }
    this.onCheckboxChange = this.onCheckboxChange.bind(this)
    this.submit = this.submit.bind(this)
  }

  toggle (username) {
    const checked = this.state.checked
    checked.has(username) ? checked.delete(username) : checked.add(username)
    this.setState({ checked })
  }

  onCheckboxChange (event) {
    event.preventDefault()
    const checked = this.state.checked
    const username = event.target.name
    event.target.checked ? checked.add(username) : checked.delete(username)
    this.setState({ checked })
  }

  submit () {
    if (this.state.checked.size === 0) return
    if (this.state.checked.size === 1) {
      const username = this.state.checked.values().next().value
      window.location = new URL(`/stats/${username}`, window.location.origin)
      return
    }
    const url = new URL('/stats', window.location.origin)
    this.state.checked.forEach(username => url.searchParams.append('usernames[]', username))
    window.location = url.toString()
  }

  keyFor (username) {
    return `${username}:${this.state.checked.has(username)}`
  }

  render () {
    return (
      <React.Fragment>
        <p>Select some users to compare.</p>
        <ul>
          { this.props.usernames.map(username =>
              <li key={this.keyFor(username)} name={username} className={styles.username}>
                <input
                  type="checkbox"
                  name={username}
                  checked={this.state.checked.has(username)}
                  onChange={this.onCheckboxChange} />
                  <span onClick={() => this.toggle(username)}>{username}</span>
              </li>
            )
          }
        </ul>
        <input className={styles.submit} enabled={this.state.checked.size !== 0} type="button" onClick={this.submit} value="Compare" />
      </React.Fragment>
    )
  }
}

Home.propTypes = {
  usernames: PropTypes.arrayOf(PropTypes.string)
}

export default Home
