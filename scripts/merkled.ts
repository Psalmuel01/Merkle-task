import { ethers } from "hardhat";

async function main() {
  const tokenAddr = "0xE7f419b437f27d3f09b174DeF166D6CCC4C7d824";
  const merkleRoot = "0xf8211c37a0f3cf0cc80169c2a241e1171a2edf410beafa7e69b8bd4cd7b56c7a"
  const merkled = await ethers.deployContract("MerkleDistributor", [tokenAddr, merkleRoot]);

  await merkled.waitForDeployment();

  console.log(`Merkle token deployed to ${merkled.target}`);
  //0xfe5f4E1c61866F8F9570fab86cE5381385eeC0Bb

  const claim = await merkled.claim()

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
