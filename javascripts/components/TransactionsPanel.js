import React, { Component } from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'
import M from 'materialize-css'

import { createEntity, deposit, withdraw, transfer } from '../actions/landing'

class TransactionsPanel extends Component {
  constructor(...args) {
    super(...args)

    this.state = {
      activeTab: 'add entity',
      addEntity: {
        type: 'User',
        name: '',
      },
      deposit: {
        entityId: '',
        amount: '',
      },
      withdraw: {
        entityId: '',
        amount: '',
      },
      transfer: {
        sourceEntityId: '',
        targetEntityId: '',
        amount: '',
      },
    }
  }

  componentDidMount() {
    M.AutoInit()
  }

  componentDidUpdate() {
    M.AutoInit()
  }

  setActiveTab(tabName) {
    this.setState({ activeTab: tabName })
  }

  setAddEntityType(e) {
    let addEntity = {...this.state.addEntity}
    addEntity.type = e.target.value
    this.setState({ addEntity: addEntity })
  }

  setAddEntityName(e) {
    let addEntity = {...this.state.addEntity}
    addEntity.name = e.target.value
    this.setState({ addEntity: addEntity })
  }

  submitAddEntity() {
    let s = this.state.addEntity
    this.props.createEntity(s.type, s.name)
    this.setState({
      addEntity: {
        type: 'User',
        name: '',
      }
    })
  }

  setDepositEntityId(e) {
    let deposit = {...this.state.deposit}
    deposit.entityId = e.target.value
    this.setState({ deposit: deposit })
  }

  setDepositAmount(e) {
    let deposit = {...this.state.deposit}
    deposit.amount = e.target.value
    this.setState({ deposit: deposit })
  }

  submitDeposit() {
    let s = this.state.deposit
    this.props.deposit(s.entityId, s.amount)
    this.setState({
      deposit: {
        entityId: '',
        amount: '',
      }
    })
  }

  setWithdrawEntityId(e) {
    let withdraw = {...this.state.withdraw}
    withdraw.entityId = e.target.value
    this.setState({ withdraw: withdraw })
  }

  setWithdrawAmount(e) {
    let withdraw = {...this.state.withdraw}
    withdraw.amount = e.target.value
    this.setState({ withdraw: withdraw })
  }

  submitWithdraw() {
    let s = this.state.withdraw
    this.props.withdraw(s.entityId, s.amount)
    this.setState({
      withdraw: {
        entityId: '',
        amount: '',
      }
    })
  }

  setTransferSourceEntityId(e) {
    let transfer = {...this.state.transfer}
    transfer.sourceEntityId = e.target.value
    this.setState({ transfer: transfer })
  }

  setTransferTargetEntityId(e) {
    let transfer = {...this.state.transfer}
    transfer.targetEntityId = e.target.value
    this.setState({ transfer: transfer })
  }

  setTransferAmount(e) {
    let transfer = {...this.state.transfer}
    transfer.amount = e.target.value
    this.setState({ transfer: transfer })
  }

  submitTransfer(e) {
    e.preventDefault()
    let s = this.state.transfer
    this.props.transfer(s.sourceEntityId, s.targetEntityId, s.amount)
    this.setState({
      transfer: {
        sourceEntityId: '',
        targetEntityId: '',
        amount: '',
      }
    })
  }

  render() {
    return (
      <div className='transactions-panel'>
        <div className='entities-pane'>
          <div className='user-pane'>
            <h2>Users</h2>
            {this.renderEntityDisplay('User')}
          </div>
          <div className='team-pane'>
            <h2>Teams</h2>
            {this.renderEntityDisplay('Team')}
          </div>
          <div className='stock-pane'>
            <h2>Stocks</h2>
            {this.renderEntityDisplay('Stock')}
          </div>
        </div>
        <div className='transaction-pane'>
          <nav className='nav-extended'>
            <div className="nav-content">
              <ul className="tabs tabs-transparent">
                {this.renderTabs()}
              </ul>
            </div>
          </nav>

          {this.renderActiveTabContent()}
        </div>
      </div>
    )
  }

  renderTabs() {
    let tabNames = ['add entity', 'deposit', 'withdraw', 'transfer']
    let tabs = []
    for (var tabName of tabNames) {
      let cname = classNames({
        'tab': true,
        'active': tabName == this.state.activeTab
      })
      tabs.push(
        <li key={tabName} className={cname}>
          <a href='javascript:void(0)'
             onClick={this.setActiveTab.bind(this, tabName)}>
            {tabName}
          </a>
        </li>
      )
    }
    return tabs
  }

  renderActiveTabContent() {
    if (this.state.activeTab == 'add entity') {
      return this.renderTabContentAddEntity()
    } else if (this.state.activeTab == 'deposit') {
      return this.renderTabContentDeposit()
    } else if (this.state.activeTab == 'withdraw') {
      return this.renderTabContentWithdraw()
    } else {
      return this.renderTabContentTransfer()
    }
  }

  renderTabContentAddEntity() {
    return (
      <div className='form'>
        <div className='row'>
          <div className="input-field col s2">
            <select onChange={this.setAddEntityType.bind(this)}
                    value={this.state.addEntity.type}>
              <option value="User">User</option>
              <option value="Team">Team</option>
              <option value="Stock">Stock</option>
            </select>
            <label>Entity Type</label>
          </div>
          <div className="input-field col s3">
            <input id="entity_name" type="text" className="validate"
                   value={this.state.addEntity.name}
                   onChange={this.setAddEntityName.bind(this)}/>
            <label htmlFor="entity_name">Name</label>
          </div>
          <div className='input-field col s1'>
            <button className='btn waves-effect waves-light'
                    onClick={this.submitAddEntity.bind(this)}>
              Add
            </button>
          </div>
        </div>
      </div>
    )
  }

  renderTabContentDeposit() {
    return (
      <div className='form'>
        <div className='row'>
          <div className="input-field col s2">
            {this.renderEntitySelect(this.state.deposit.entityId, this.setDepositEntityId.bind(this))}
            <label>Entity</label>
          </div>
          <div className="input-field col s3">
            <input id="deposit_amount" type="text" className="validate"
                   value={this.state.deposit.amount}
                   onChange={this.setDepositAmount.bind(this)}/>
            <label htmlFor="deposit_amount">Amount</label>
          </div>
          <div className='input-field col s1'>
            <button className='btn waves-effect waves-light'
                    onClick={this.submitDeposit.bind(this)}>
              Deposit
            </button>
          </div>
        </div>
      </div>
    )
  }

  renderTabContentWithdraw() {
    return (
      <div className='form'>
        <div className='row'>
          <div className="input-field col s2">
            {this.renderEntitySelect(this.state.withdraw.entityId, this.setWithdrawEntityId.bind(this))}
            <label>Entity</label>
          </div>
          <div className="input-field col s3">
            <input id="withdraw_amount" type="text" className="validate"
                   value={this.state.withdraw.amount}
                   onChange={this.setWithdrawAmount.bind(this)} />
            <label htmlFor="withdraw_amount">Amount</label>
          </div>
          <div className='input-field col s1'>
            <button className='btn waves-effect waves-light'
                    onClick={this.submitWithdraw.bind(this)}>
              Withdraw
            </button>
          </div>
        </div>
      </div>
    )
  }

  renderTabContentTransfer() {
    return (
      <div>
        <form>
          <div className='row'>
            <div className="input-field col s2">
              {this.renderEntitySelect(this.state.transfer.sourceEntityId, this.setTransferSourceEntityId.bind(this))}
              <label>From</label>
            </div>
            <div className="input-field col s2">
              {this.renderEntitySelect(this.state.transfer.targetEntityId, this.setTransferTargetEntityId.bind(this))}
              <label>To</label>
            </div>
            <div className="input-field col s3">
              <input id="transfer_amount" type="text" className="validate"
                     value={this.state.transfer.amount}
                     onChange={this.setTransferAmount.bind(this)} />
              <label htmlFor="transfer_amount">Amount</label>
            </div>
            <div className='input-field col s1'>
              <button className='btn waves-effect waves-light'
                      onClick={this.submitTransfer.bind(this)}>
                Transfer
              </button>
            </div>
          </div>
        </form>
      </div>
    )
  }

  renderEntitySelect(value, onChange) {
    let rows = {}
    for (var entity of this.props.entities) {
      rows[entity.type] = rows[entity.type] || []
      rows[entity.type].push(
        <option key={entity.id} value={entity.id}>{entity.name}</option>
      )
    }
    return (
      <select value={value} onChange={onChange}>
        <option value='' disabled>Choose Entity</option>
        <optgroup label="User">
          {rows['User']}
        </optgroup>
        <optgroup label="Team">
          {rows['Team']}
        </optgroup>
        <optgroup label="Stock">
          {rows['Stock']}
        </optgroup>
      </select>
    )
  }

  renderEntityDisplay(entityType) {
    let rows = []
    for (var entity of this.props.entities) {
      if (entity.type == entityType) {
        rows.push(
          <tr key={entity.id}>
            <td>{entity.name}</td>
            <td>{entity.balance}</td>
          </tr>
        )
      }
    }
    return (
      <table>
        <tbody>
          {rows}
        </tbody>
      </table>
    )
  }
}

let mapStateToProps = (state, props) => {
  let entities = []
  for (var entityId in state.entities.entities) {
    entities.push(state.entities.entities[entityId])
  }
  return {
    entities: entities
  }
}

let mapDispatchToProps = (dispatch) => {
  return {
    createEntity: (type, name) => {
      dispatch(createEntity(type, name))
    },
    deposit: (entityId, amount) => {
      dispatch(deposit(entityId, amount))
    },
    withdraw: (entityId, amount) => {
      dispatch(withdraw(entityId, amount))
    },
    transfer: (sourceEntityId, targetEntityId, amount) => {
      dispatch(transfer(sourceEntityId, targetEntityId, amount))
    }
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(TransactionsPanel)
