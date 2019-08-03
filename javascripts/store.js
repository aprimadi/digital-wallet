import { createStore, applyMiddleware } from 'redux'
import thunk from 'redux-thunk'
import { batchDispatchMiddleware } from 'redux-batched-actions'

import rootReducer from './reducers/root'

const MIDDLEWARES = applyMiddleware(
  thunk,
  batchDispatchMiddleware,
)

const emptyStore = createStore(
  rootReducer,
  MIDDLEWARES
)

export default emptyStore

export function initializeStore(state) {
  return createStore(
    rootReducer,
    state,
    MIDDLEWARES,
  )
}
