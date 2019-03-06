import CtrlpanelCore from '@ctrlpanel/core'
import findAccountsForHostname from '@ctrlpanel/find-accounts-for-hostname'

let core = new CtrlpanelCore()
let state = null

function flutterState (state) {
  return {
    kind: state.kind || 'empty',

    // Locked
    handle: state.handle || null,
    saveDevice: state.saveDevice || null,
    secretKey: state.secretKey || null,
    syncToken: (state.handle && state.secretKey) ? core.getSyncToken(state) : null,

    // Unlocked
    parsedEntries: state.decryptedEntries ? core.getParsedEntries(state) : null,

    // Connected
    hasPaymentInformation: state.hasPaymentInformation || null,
    subscriptionStatus: state.subscriptionStatus || null,
    trialDaysLeft: state.trialDaysLeft || null,
  }
}

window['Ctrlpanel'] = {
  randomAccountPassword () {
    return CtrlpanelCore.randomAccountPassword()
  },
  randomHandle () {
    return CtrlpanelCore.randomHandle()
  },
  randomMasterPassword () {
    return CtrlpanelCore.randomMasterPassword()
  },
  randomSecretKey () {
    return CtrlpanelCore.randomSecretKey()
  },

  boot (apiHost, deseatmeApiHost) {
    if (apiHost == null) apiHost = undefined
    if (deseatmeApiHost == null) deseatmeApiHost = undefined

    core = new CtrlpanelCore(apiHost, deseatmeApiHost)
  },
  init (syncToken) {
    if (syncToken == null) syncToken = undefined

    return flutterState(state = core.init(syncToken))
  },
  lock () {
    return flutterState(state = core.lock(state))
  },

  async signup (handle, secretKey, masterPassword, saveDevice) {
    return flutterState(state = await core.signup(state, { handle, secretKey, masterPassword }, saveDevice))
  },
  async login (handle, secretKey, masterPassword, saveDevice) {
    return flutterState(state = await core.login(state, { handle, secretKey, masterPassword }, saveDevice))
  },
  async unlock (masterPassword) {
    return flutterState(state = await core.unlock(state, { masterPassword }))
  },
  async connect () {
    return flutterState(state = await core.connect(state))
  },
  async sync () {
    if (state.kind === 'unlocked') await window['Ctrlpanel'].connect()
    if (state.kind !== 'connected') throw new Error(`Invalid state: ${state.kind}`)

    return flutterState(state = await core.sync(state))
  },

  async setPaymentInformation (paymentInformation) {
    if (state.kind === 'unlocked') await window['Ctrlpanel'].connect()
    if (state.kind !== 'connected') throw new Error(`Invalid state: ${state.kind}`)

    return flutterState(state = await core.setPaymentInformation(state, paymentInformation))
  },

  accountsForHostname (hostname) {
    const { accounts } = core.getParsedEntries(state)
    const accountList = Object.keys(accounts).map(id => Object.assign({ id }, accounts[id]))

    return findAccountsForHostname(hostname, accountList)
  },

  async createAccount (id, account) {
    if (state.kind === 'unlocked') await window['Ctrlpanel'].connect()
    if (state.kind !== 'connected') throw new Error('Vault is locked')

    return flutterState(state = await core.createAccount(state, id.toLowerCase(), account))
  },
  async deleteAccount (id) {
    if (state.kind === 'unlocked') await window['Ctrlpanel'].connect()
    if (state.kind !== 'connected') throw new Error('Vault is locked')

    return flutterState(state = await core.deleteAccount(state, id.toLowerCase()))
  },
  async updateAccount (id, account) {
    if (state.kind === 'unlocked') await window['Ctrlpanel'].connect()
    if (state.kind !== 'connected') throw new Error('Vault is locked')

    return flutterState(state = await core.updateAccount(state, id.toLowerCase(), account))
  },
  async createInboxEntry (id, inboxEntry) {
    if (state.kind === 'unlocked') await window['Ctrlpanel'].connect()
    if (state.kind !== 'connected') throw new Error('Vault is locked')

    return flutterState(state = await core.createInboxEntry(state, id.toLowerCase(), inboxEntry))
  },
  async deleteInboxEntry (id) {
    if (state.kind === 'unlocked') await window['Ctrlpanel'].connect()
    if (state.kind !== 'connected') throw new Error('Vault is locked')

    return flutterState(state = await core.deleteInboxEntry(state, id.toLowerCase()))
  },
  async importFromDeseatme (exportToken) {
    if (state.kind === 'unlocked') await window['Ctrlpanel'].connect()
    if (state.kind !== 'connected') throw new Error('Vault is locked')

    return flutterState(state = await core.importFromDeseatme(state, exportToken))
  },

  async clearStoredData () {
    return flutterState(state = await core.clearStoredData(state))
  },
  async deleteUser () {
    return flutterState(state = await core.deleteUser(state))
  }
}
