import assign from 'lodash/assign'
import * as types from '../constants/action-types'

export default function landing(state, action) {
  state = state || {}

  switch (action.type) {
    case types.SET_ERROR:
      state = assign({}, state, { error: action.error })
      return state
    default:
      return state
  }
}