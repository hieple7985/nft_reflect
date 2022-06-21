#import "utils.mligo" "UTILS"

let _fail_str = UTILS.fail_str
let _pass_str = UTILS.pass_str

let to_be_equal (one, two : int * int) : nat =
    if one=two then let _ = Test.log("Test Passed") in 0n
    else
        let _ = Test.log(_fail_str, "Expected", one, "to be equal to", two) in
        1n

let to_be_less_than (a, b : int * int) : nat =
    if a<b then 0n
    else
        // let fails = UTILS.fail_test() in
        let _ = Test.log(_fail_str, "expected", a, "to be less than", b) in
        1n
    
