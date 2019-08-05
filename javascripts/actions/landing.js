import $ from 'jquery'
import { normalize } from 'normalizr'

import * as types from '../constants/action-types'
import CSRF from '../helpers/CSRF'
import { EntityListSchema } from '../schema'

export function refreshEntities(response) {
  return {
    type: types.REFRESH_ENTITIES,
    response: response,
  }
}

export function createEntity(type, name) {
  return (dispatch) => {
    $.post('/entities', {
      authenticity_token: CSRF.token(),
      entity: {
        type: type,
        name: name,
      },
    }).done((data) => {
      $.get('/entities').done((data) => {
        let response = normalize(data, EntityListSchema)
        dispatch(refreshEntities(response))
      })
    }).fail((data) => {
      // TODO
    })
  }
}

export function deposit(entityId, amount) {
  return (dispatch) => {
    $.post('/transactions/deposit', {
      authenticity_token: CSRF.token(),
      entity_id: entityId,
      amount: amount,
    }).done((data) => {
      $.get('/entities').done((data) => {
        let response = normalize(data, EntityListSchema)
        dispatch(refreshEntities(response))
      })
    }).fail((data) => {
      // TODO
    })
  }
}

export function withdraw(entityId, amount) {
  return (dispatch) => {
    $.post('/transactions/withdraw', {
      authenticity_token: CSRF.token(),
      entity_id: entityId,
      amount: amount,
    }).done((data) => {
      $.get('/entities').done((data) => {
        let response = normalize(data, EntityListSchema)
        dispatch(refreshEntities(response))
      })
    }).fail((data) => {
      // TODO
    })
  }
}

export function transfer(sourceEntityId, targetEntityId, amount) {
  return (dispatch) => {
    $.post('/transactions/transfer', {
      authenticity_token: CSRF.token(),
      source_entity_id: sourceEntityId,
      target_entity_id: targetEntityId,
      amount: amount,
    }).done((data) => {
      $.get('/entities').done((data) => {
        let response = normalize(data, EntityListSchema)
        dispatch(refreshEntities(response))
      })
    }).fail((data) => {
      // TODO
    })
  }
}
