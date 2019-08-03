import React, { Component } from 'react'
import { connect } from 'react-redux'

class TransactionsPanel extends Component {
  render() {
    return (
      <div>
        Hi, world!
      </div>
    )
  }
}

let mapStateToProps = (state, props) => {
  return {}
}

let mapDispatchToProps = (dispatch) => {
  return {}
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(TransactionsPanel)
