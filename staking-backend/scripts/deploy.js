const {ethers} = require("hardhat");

async function main() {
    /*
  A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
  so whitelistContract here is a factory for instances of our Whitelist Contract.
  */
    const WDTokenContract = await ethers.getContractFactory("WDToken");

    // deploy the contract with 10 as the constructor's argument (i.e 10 is max no. of whiteisted address allowed.)
    const deployedWDTokenContract = await WDTokenContract.deploy();

    // wait for the deployment to finish
    await deployedWDTokenContract.deployed();

    // print the address of the deployed contract
    console.log("WDToken Contract Address:", deployedWDTokenContract.address);
}

// Call main function and catch if there is any error
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });