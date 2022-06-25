#import "expect/assertions.mligo" "EXPECT"
#import "../contracts/nft.mligo" "FA2"
#import "../contracts/nft.mligo" "FA2_NFT"

// Mock contracts
#import "mock_contracts/view_caller.mligo" "View_caller"
#import "mock_contracts/call_counter.mligo" "CallCounter"
#import "mock_contracts/data_oracle.mligo" "MockOracle"
#import "mock_contracts/data_oracle_errors.mligo" "MockOracleError"

// Utils
#import "utils.mligo" "UTILS"
#import "utils.originate_contracts.mligo" "OriginateContract"

let add_fail = EXPECT.add_fail
let add_assert = EXPECT.add_assert
let get_initial_storage = UTILS.get_initial_storage
module List_helper = UTILS.List_helper

// #include "view_metadata.unit.test.mligo"
// Tests
#include "unit/index.mligo"
#include "view_metadata.oracle_fails.test.mligo"
#include "view_metadata.no_mutate_data.test.mligo"
#include "view_metadata.one_to_one_mappings.test.mligo"
#include "add_mutation_oracle.test.mligo"
#include "add_mutation_condition_mappings.test.mligo"
