const {ethers} = require("hardhat");

async function main() {
    /*
  A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
  so whitelistContract here is a factory for instances of our Whitelist Contract.
  */
    const EXToken1Contract = await ethers.getContractFactory("EXToken1");

    // deploy the contract with 10 as the constructor's argument (i.e 10 is max no. of whiteisted address allowed.)
    const deployedEXToken1Contract = await EXToken1Contract.deploy();

    // wait for the deployment to finish
    await deployedEXToken1Contract.deployed();

    // print the address of the deployed contract
    console.log("WDToken Contract Address:", deployedEXToken1Contract.address);
}

// Call main function and catch if there is any error
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });