#import "../expect/assertions.mligo" "EXPECT"
#import "../utils.mligo" "UTILS"

let add_fail = EXPECT.add_fail
let add_assert = EXPECT.add_assert
let get_initial_storage = UTILS.get_initial_storage

// #include "view_metadata.unit.test.mligo"
// Tests
#include "parseCondition_int.utils.mligo"
#include "parseCondition_nat.utils.mligo"
#include "parseCondition_string.utils.mligo"
#include "parseCondition.oracleResponse.utils.mligo"
