import { ethers } from "hardhat";

async function main() {
  const tokenAddr = "0xE7f419b437f27d3f09b174DeF166D6CCC4C7d824";
  const merkleRoot =
    "0xf8211c37a0f3cf0cc80169c2a241e1171a2edf410beafa7e69b8bd4cd7b56c7a";
  const merkled = await ethers.deployContract("MerkleDistributor", [
    tokenAddr,
    merkleRoot,
  ]);

  await merkled.waitForDeployment();

  console.log(`Merkle token deployed to ${merkled.target}`);
  //0xfe5f4E1c61866F8F9570fab86cE5381385eeC0Bb

  const [addr1, addr2, addr3, addr4, addr5] = await ethers.getSigners();
  const addresses = [
    addr1.address,
    addr2.address,
    addr3.address,
    addr4.address,
    addr5.address,
  ];

  const merkle = [
    0x931fd3a38611a0c1d2ec3d34b47329a54f28e840699c32699028a617448b8d5b,
    0xe41473073bbcc246e52f363679853a58d23be0b15aeddf9716350cff594bc837,
    0x0000000000000000000000000000000000000000000000000000000000000000,
    0x0000000000000000000000000000000000000000000000000000000000000000,
  ];

  const merkleProofs = [
    [
      "0x931fd3a38611a0c1d2ec3d34b47329a54f28e840699c32699028a617448b8d5b",
      "0xe41473073bbcc246e52f363679853a58d23be0b15aeddf9716350cff594bc837",
      "0x0000000000000000000000000000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000000000000000000000000000",
    ],
    [
      "0x1daab6e461c57679d093fe722a8bf8ba48798a5a9386000d2176d175bc5fae57",
      "0x23bb20f448a3c9394f8023adf8dbbfe22c5fe0db58eab15634ecf0fca1474e66",
      "0x0000000000000000000000000000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000000000000000000000000000",
    ],
    [
      "0xcd0ecbfb029df47faf380ab339af1900961f49416d4a903b10caec8698022415",
      "0x23bb20f448a3c9394f8023adf8dbbfe22c5fe0db58eab15634ecf0fca1474e66",
      "0x0000000000000000000000000000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000000000000000000000000000",
    ],
  ];

  // console.log(addresses);
  // '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
  // '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
  // '0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC',
  // '0x90F79bf6EB2c4f870365E785982E1f101E93b906',
  // '0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65'

  // console.log(await merkled.addEnabledAddresses(addresses, [1,2,3,4,5]))

  const claim = await merkled.claim(
    1,
    addresses[1],
    ethers.parseEther("2"),
    merkleProofs[1]
  );

  // const enable = await merkled.addEnabledAddresses();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
