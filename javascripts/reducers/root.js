import mergeWith from 'lodash.mergewith'
import { combineReducers } from 'redux'

function entities(state, action) {
  function customizer(objValue, srcValue) {
    if (isArray(srcValue)) {
      return srcValue
    }
  }

  state = state || {}

  if (action.response && action.response.entities) {
    let newState = assign({}, state)
    for (var key in action.response.entities) {
      newState[key] = assign(
        {},
        newState[key],
        action.response.entities[key]
      )
      for (var id in action.response.entities[key]) {
        newState[key][id] = mergeWith(
          {},
          (state[key] || {})[id],
          action.response.entities[key][id],
          customizer
        )
      }
    }
    return newState
  }
  return state
}

function data(state, action) {
  return state || {}
}

const appReducer = combineReducers({
  entities,
  data,
})

const rootReducer = (state, action) => {
  // Any reducers that transcends beyond the tree structure should be here
  return appReducer(state, action)
}

export default rootReducer
