import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'

import { initializeStore } from '../store'
import TransactionsPanel from '../components/TransactionsPanel'

export default function() {
  let el = document.getElementById('landing')
  if (el) {
    let state = {
      data: {}
    }
    let store = initializeStore(state)
    ReactDOM.render(
      <Provider store={store}>
        <TransactionsPanel />
      </Provider>,
      el,
    )
  }
}
