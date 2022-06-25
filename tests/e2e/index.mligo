#import "../expect/assertions.mligo" "EXPECT"
#import "../../contracts/nft.mligo" "FA2"
#import "../../contracts/nft.mligo" "FA2_NFT"

// View Caller contracts
#import "../mock_contracts/view_caller.mligo" "View_caller"

// Utils
#import "../utils.mligo" "UTILS"
#import "../utils.originate_contracts.mligo" "OriginateContract"

let add_fail = EXPECT.add_fail
let add_assert = EXPECT.add_assert
let get_initial_storage = UTILS.get_initial_storage
module List_helper = UTILS.List_helper

// #include "view_metadata.unit.test.mligo"
// Tests
#include "view_metadata.one_to_one_mappings.test.mligo"
