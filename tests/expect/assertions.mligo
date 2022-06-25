#import "INT.mligo" "INT"
#import "utils.mligo" "UTILS"

let _fail_str = UTILS.fail_str
let _pass_str = UTILS.pass_str
let print_fail (type a) (val : a) : unit =
    UTILS.print_fail val

let to_fail (result : test_exec_result) : nat =
    // let expected = Test.eval expected in
    match result with
    | Fail _ -> 0n
    | Success _ ->
        let _ = Test.log(print_fail ("Transaction was supposed to fail but passed with", result)) in
        1n

let log_bad_fail(fail, expected_fail_str : michelson_program * string ) =
    let _ = Test.log(print_fail ("Transaction was supposed to fail with " ^ expected_fail_str ^ " but failed with", fail))
    in ()

let to_fail_with (result, expected_fail_str : test_exec_result * string) : nat =
    // let expected = Test.eval expected in
    match result with
      Success _ -> let _ = Test.log(_fail_str ^ "Transaction was supposed to fail but passed with", result) in 1n
    | Fail fail_exec ->
        let ans = match fail_exec with
          Rejected (fail, _) ->
            let expected_fail = Test.compile_value expected_fail_str in

            if(Test.michelson_equal fail expected_fail) then 0n
            else let _ = log_bad_fail(fail, expected_fail_str) in 1n

        | Balance_too_low _ ->
            let _ = Test.log(_fail_str ^ "Transaction was supposed to fail with" ^ expected_fail_str ^ "but failed with ", "Balance too low")
            in 1n
        | Other fail_str ->
            if(fail_str = expected_fail_str) then 0n
            else let _ = Test.log(_fail_str ^ "Expected transaction to fail with ---" ^ expected_fail_str ^ "--- but instead failed with ---" ^ fail_str)
                in 1n
            in ans

let not_to_fail (result : test_exec_result) : nat =
    // let expected = Test.eval expected in
    match result with
    | Success _ -> 0n
    | Fail _ ->
        let _ = Test.log(_fail_str ^ "Transaction was supposed to pass but failed with", result) in
        1n

let to_be_true (condition: bool) : nat =
    if(condition = true) then 0n
    else 1n

let to_be_false (condition: bool) : nat =
    if(condition = true) then 1n
    else 0n

// let _ = Test.log(UTILS.test_results)
let results = UTILS.tost_result
let result = UTILS.tost_result
let add_assert = UTILS.add_assert
let add_fail = UTILS.add_fail

module INT = INT
#include "MAP.mligo"
#include "BIG_MAP.mligo"
#include "STRING.mligo"
#include "BYTES.mligo"
#include "LIST.mligo"

