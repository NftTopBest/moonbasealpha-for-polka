import CTC from '~/abis/CTC.json'
import Vote from '~/abis/Vote.json'

const chainIdMap = {
  'dev.web3nft.social': '0x4',
  'moonbaseAlpha.web3nft.social': '0x507',
}
const gitBranch = import.meta.env.VITE_VERCEL_GIT_COMMIT_REF
export const CHAIN_ID = chainIdMap[gitBranch] || '0x4'
export const CHAIN_MAP = {
  '0x4': {
    chainId: '0x4',
    chainName: 'Rinkeby Test Network',
    blockExplorerUrls: ['https://rinkeby.etherscan.io'],
    nativeCurrency: { name: 'Rinkeby Ether', symbol: 'RIN', decimals: 18 },
    rpcUrls: ['https://rinkeby.infura.io/v3/'],
  },
  '0x507': {
    chainId: '0x507',
    chainName: 'Moonbase Alpha',
    blockExplorerUrls: ['https://moonbase.moonscan.io/'],
    nativeCurrency: { name: 'DEV', symbol: 'DEV', decimals: 18 },
    rpcUrls: ['https://rpc.api.moonbase.moonbeam.network'],
  },
}

export const CHAIN_CONTRACT_MAP = {
  CTC: {
    '0x4': '0x17F6BDF57384FD9F24F1d9A4681c3a9dc839d79e',
    '0x507': '0x83B06d09B99AD2641Dd9b1132E8Ce8809b623433',
  },
  Vote: {
    '0x4': '0x7b454Ef73abc93Ff775C3291a72b138822F955Da',
    '0x507': '0xc6eD496eaFAaCD3254adD3e62Cd3f1D87b8d89Ac',
  },
}

export const CHAIN_CONTRACT_ABI_MAP = {
  CTC,
  Vote,
}
