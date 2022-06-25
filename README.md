# Real World Art NFTs on Tezos

## Metadata
The metadata for these NFTs can be mutated. To make your NFTs have names, descriptions, display images, etc that change, you'll need
- [An oracle](#oracle):
- For token images, links to the images you're planning to use.

### How To
When you mint your token, make sure you add your token metadata fields. If your oracle ever fails for any reason, the metadata you've entered will be used.
- After minting, call `addOracle(oracle_contract_address, oracle_parameters)`, and `value` is a map.
- Then, call `addMetadataMutation(field, (condition, value) map)`. `condition` is a string, and `value` is a map. You can only call addMetadataMutation if you have previously added an oracle with `addOracle`

You can get data for the `addMetadataMutation(field, (condition, value) map)` function at the [NFT Reflect Utilities](https://littlezigy.github.io/nft-reflect-utils/) website. Enter in the conditions and their corresponding fields values in the inputs on the page, and click the `Get Code` button.

## Oracle
You can use the oracle at
If you create an oracle, build off of contract/oracle_types and add a view data that returns a type `response`. view_metadata will not be able to call your oracle if this view (`data`) is not present
