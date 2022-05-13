from solcx import compile_standard, install_solc
import json
from web3 import Web3
import os
from dotenv import load_dotenv

load_dotenv()

install_solc("0.6.0")

# read solidity file:
with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

# compile solidity:
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.6.0",
)
with open("compiles_code.json", "w") as file:
    json.dump(compiled_sol, file)

# get bytecode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["Simple_Storage"]["evm"][
    "bytecode"
]["object"]

# get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["Simple_Storage"]["abi"]

# to connect to ganache
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545", request_kwargs={"timeout": 60}))

# get the network id
chain_id = 1337
# fake value
value = w3.toWei(0.1, "ether")
gas_price = w3.toWei(5, "gwei")

# fake address
my_address = "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1"
foreign_address = "0xFFcf8FDEE72ac11b5c542428B35EEF5769C409f0"
gas = 100000

private_key = os.getenv("PRIVATE_KEY")
# print(w3.isConnected())
# creating contract in python
Simple_Storage = w3.eth.contract(abi=abi, bytecode=bytecode)
# to get the latest transaction nonce
nonce = w3.eth.getTransactionCount(my_address)
# print(nonce)
# 1. build transaction
transaction = {
    "chainId": chain_id,
    "to": foreign_address,
    "value": value,
    "nonce": nonce,
    "gas": gas,
    "gasPrice": gas_price,
}
transaction
#  2 signing contract
signed_txn = w3.eth.account.sign_transaction(transaction, private_key)
# print(signed_txn)
# print(private_key)
# sending signed transactions
txn_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
# wait for receipt
txn_receipt = w3.eth.wait_for_transaction_receipt(txn_hash)

print("Deployed!")
# working with the contract, we need:
# contract address
# contract ABI

# initializing value of favourite number
simple_storage = w3.eth.contract(address=txn_receipt.contractAddress, abi=abi)
# print(simple_storage.functions.retrieve())
# print(simple_storage.functions.retrieve().call({"from": my_address}))
# print(simple_storage.functions.store())
# build transaction
print("Updating contracting...")
store_txn = simple_storage.functions.store(15).buildTransaction(
    {
        "chainId": chain_id,
        "to": foreign_address,
        "value": value,
        "nonce": nonce + 1,
        "gas": gas,
        "gasPrice": gas_price,
    }
)
signed_store_txn = w3.eth.account.sign_transaction(store_txn, private_key=private_key)
send_store_txn_hash = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
txn_receipt = w3.eth.wait_for_transaction_receipt(send_store_txn_hash)
print("updated")
# print(simple_storage.functions.retrieve().call({"from" : my_address}))
