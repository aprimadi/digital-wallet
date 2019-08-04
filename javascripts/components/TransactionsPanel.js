import React, { Component } from 'react'
import { connect } from 'react-redux'
import classNames from 'classnames'
import M from 'materialize-css'

class TransactionsPanel extends Component {
  constructor(...args) {
    super(...args)

    this.state = {
      activeTab: 'add entity',
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

  render() {
    return (
      <div className='transactions-panel'>
        <div className='entities-pane'>
          <div className='user-pane'>
            <h2>Users</h2>
          </div>
          <div className='team-pane'>
            <h2>Teams</h2>
          </div>
          <div className='stock-pane'>
            <h2>Stocks</h2>
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
      <form>
        <div className='row'>
          <div className="input-field col s2">
            <select>
              <option value="1">User</option>
              <option value="2">Team</option>
              <option value="3">Stock</option>
            </select>
            <label>Entity Type</label>
          </div>
          <div className="input-field col s3">
            <input id="entity_name" type="text" className="validate" />
            <label htmlFor="entity_name">Name</label>
          </div>
          <div className='input-field col s1'>
            <button className='btn waves-effect waves-light'>Add</button>
          </div>
        </div>
      </form>
    )
  }

  renderTabContentDeposit() {
    return (
      <form>
        <div className='row'>
          <div className="input-field col s2">
            <select>
              <optgroup label="User">
                <option value="1">Alice</option>
                <option value="2">Bob</option>
              </optgroup>
              <optgroup label="Team">
                <option value="HCL Holding">HCL Holding</option>
              </optgroup>
              <optgroup label="Stock">
                <option value="AAPL">AAPL</option>
              </optgroup>
            </select>
            <label>Entity</label>
          </div>
          <div className="input-field col s3">
            <input id="deposit_amount" type="text" className="validate" />
            <label htmlFor="deposit_amount">Amount</label>
          </div>
          <div className='input-field col s1'>
            <button className='btn waves-effect waves-light'>Deposit</button>
          </div>
        </div>
      </form>
    )
  }

  renderTabContentWithdraw() {
    return (
      <form>
        <div className='row'>
          <div className="input-field col s2">
            <select>
              <optgroup label="User">
                <option value="1">Alice</option>
                <option value="2">Bob</option>
              </optgroup>
              <optgroup label="Team">
                <option value="HCL Holding">HCL Holding</option>
              </optgroup>
              <optgroup label="Stock">
                <option value="AAPL">AAPL</option>
              </optgroup>
            </select>
            <label>Entity</label>
          </div>
          <div className="input-field col s3">
            <input id="withdraw_amount" type="text" className="validate" />
            <label htmlFor="withdraw_amount">Amount</label>
          </div>
          <div className='input-field col s1'>
            <button className='btn waves-effect waves-light'>Withdraw</button>
          </div>
        </div>
      </form>
    )
  }

  renderTabContentTransfer() {
    return (
      <div>
        <form>
          <div className='row'>
            <div className="input-field col s2">
              <select>
                <optgroup label="User">
                  <option value="1">Alice</option>
                  <option value="2">Bob</option>
                </optgroup>
                <optgroup label="Team">
                  <option value="HCL Holding">HCL Holding</option>
                </optgroup>
                <optgroup label="Stock">
                  <option value="AAPL">AAPL</option>
                </optgroup>
              </select>
              <label>From</label>
            </div>
            <div className="input-field col s2">
              <select>
                <optgroup label="User">
                  <option value="1">Alice</option>
                  <option value="2">Bob</option>
                </optgroup>
                <optgroup label="Team">
                  <option value="HCL Holding">HCL Holding</option>
                </optgroup>
                <optgroup label="Stock">
                  <option value="AAPL">AAPL</option>
                </optgroup>
              </select>
              <label>To</label>
            </div>
            <div className="input-field col s3">
              <input id="transfer_amount" type="text" className="validate" />
              <label htmlFor="transfer_amount">Amount</label>
            </div>
            <div className='input-field col s1'>
              <button className='btn waves-effect waves-light'>Transfer</button>
            </div>
          </div>
        </form>
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
