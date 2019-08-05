import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import { normalize } from 'normalizr'

import { initializeStore } from '../store'
import TransactionsPanel from '../components/TransactionsPanel'
import { EntityListSchema } from '../schema'

export default function() {
  let el = document.getElementById('landing')
  if (el) {
    let nData = normalize(window.data.entities, EntityListSchema)
    let state = {
      entities: nData.entities,
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
