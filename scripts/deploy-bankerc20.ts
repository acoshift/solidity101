import { ethers } from "hardhat"
import { BankERC20__factory } from "../typechain"

async function main() {
  const signers = await ethers.getSigners()

  const C = new BankERC20__factory(signers[0])
  const c = await C.deploy('0xa9bcB45E794C7dEb3D2D18eb83EC5f060c835BE4')
  await c.deployed()

  console.log("BankERC20 deployed to:", c.address)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
