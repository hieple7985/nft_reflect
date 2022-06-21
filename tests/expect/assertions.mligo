#import "INT.mligo" "INT"
#import "MAP.mligo" "MAP"
#import "utils.mligo" "UTILS"

let _fail_str = UTILS.fail_str
let _pass_str = UTILS.pass_str


let to_fail (result : test_exec_result) : nat =
    // let expected = Test.eval expected in
    match result with
    | Fail _ -> 0n
    | Success _ ->
        let _ = Test.log(_fail_str ^ "Transaction was supposed to fail but passed with", result) in
        1n

let not_to_fail (result : test_exec_result) : nat =
    // let expected = Test.eval expected in
    match result with
    | Success _ -> 0n
    | Fail _ ->
        let _ = Test.log(_fail_str ^ "Transaction was supposed to pass but failed with", result) in
        1n

// let _ = Test.log(UTILS.test_results)
let results = UTILS.tost_result
let result = UTILS.tost_result
let add_fail = UTILS.add_fail


(*
let to_fail_with (result, fail_str : test_exec_result * string) : bool =
    // let expected = Test.eval expected in
    match result with
    | Fail fail_str -> true
    | Fail _ -> let _ = Test.log("Expected to fail with " ^ fail_str ^ " but failed with ", result) in false
    | Success _ -> let _ = Test.log(_fail_str ^ "Transaction was supposed to fail but passed with", result) in true
*)

module INT = INT
module MAP = MAP
