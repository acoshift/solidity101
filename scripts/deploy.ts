import { ethers } from "hardhat"
import { Bank__factory } from "../typechain"

async function main() {
  const signers = await ethers.getSigners()

  const C = new Bank__factory(signers[0])
  const c = await C.deploy()
  await c.deployed()

  // address contract = hash(signer + nonce)
  console.log("Bank deployed to:", c.address)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
