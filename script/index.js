const Web3 = require('web3')

const Stock = require('../build/contracts/Stock.json')

const init = async () => {
    const web3 = new Web3('http://127.0.0.1:9545/')

    const id = await web3.eth.net.getId()
    const deployedNetwork = Stock.networks[id]
    const contract =  new web3.eth.Contract(Stock.abi,deployedNetwork.address)

    const address = await web3.eth.getAccounts()

    await contract.methods.mint(address[1], 02).send({from: address[1], gas: 700000})
    const owner = await contract.methods.ownerOf(02).call()
    console.log("owner:",owner)

    await contract.methods.safeTransferFrom(address[1],address[2],02).send({from: address[1], gas: 700000})

    const results = await contract.getPastEvents(
        'Transfer',
        {}
    )

    console.log(results)
}

init()