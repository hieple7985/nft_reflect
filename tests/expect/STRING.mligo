module STRING =
struct
    let to_equal (a, b : string * string) : nat =
        if a=b then 0n
        else let _ = Test.log(_fail_str ^ "Expected " ^ a ^ " to equal " ^ b) in 1n
end
