import { ethers } from "hardhat";

async function main() {
  const [addr1, addr2, addr3, addr4, addr5] = await ethers.getSigners();
  const addresses = [
    addr1.address,
    addr2.address,
    addr3.address,
    addr4.address,
    addr5.address,
  ];

  const amounts = [
    ethers.parseEther("1"),
    ethers.parseEther("2"),
    ethers.parseEther("3"),
    ethers.parseEther("4"),
    ethers.parseEther("5"),
  ];

  const getMerkle = await ethers.deployContract("MerkleRootGenerator", []);
  await getMerkle.waitForDeployment();
  console.log(`Merkle token deployed to ${getMerkle.target}`);
  //   0xfe5f4E1c61866F8F9570fab86cE5381385eeC0Bb test

  const merkleRoots = await getMerkle.generateMerkleRoot(addresses, amounts);
  console.log(`Merkle root: ${merkleRoots}`);
  //0xf8211c37a0f3cf0cc80169c2a241e1171a2edf410beafa7e69b8bd4cd7b56c7a
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
