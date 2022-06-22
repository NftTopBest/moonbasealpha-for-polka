<script setup lang="ts">
import {
  web3Accounts,
  web3Enable,
  web3FromAddress,
} from '@polkadot/extension-dapp'

import { Recurrer, Scheduler, oakConstants } from 'oak-js-library'

const emit = defineEmits(['update:modelValue'])
interface Props {
  address: string
}
const {
  address,
} = defineProps<Props>()

const doConnect = async() => {
  const allInjected = await web3Enable(import.meta.env.VITE_PROJECT_NAME)
  console.log('====> allInjected :', allInjected)
  const allAccounts = await web3Accounts()
  const account = allAccounts[0].address
  const injector = await web3FromAddress(account)
  return { account, injector }
}

const doSubscribe = async() => {
  const { account, injector } = await doConnect()
  const providedID = account
  const scheduler = new Scheduler(oakConstants.OakChains.STUR)
  const recurrer = new Recurrer()
  const recurrences = 5
  const hourOfDay = 12 // noon UTC
  const dateOfMonth = 1 // first day of month
  // timestamps output is a 5-item array of unix timestamps
  const timestamps = recurrer.getMonthlyRecurringTimestampsByDate(
    Date.now(),
    recurrences,
    hourOfDay,
    dateOfMonth,
  )
  const senderAddress = account
  const receiverAddress = '13MhRhYPTphvQbbipGt1TTuAnP5m2FGkvUXSY2JwjhkgD3f3'
  const amount = 1000000000
  const extrinsicHex = await scheduler.buildScheduleNativeTransferExtrinsic(
    senderAddress,
    providedID,
    timestamps,
    receiverAddress,
    amount,
    injector.signer,
  )
  console.log('====> extrinsicHex :', extrinsicHex)
  const tx = await scheduler.sendExtrinsic(extrinsicHex, (result) => {
    console.log('====> result :', result)
  })
  console.log('====> tx :', tx)
}
</script>
<template>
  <btn-black :is-loading="false" @click="doSubscribe">
    Monthly Donate
  </btn-black>
</template>
