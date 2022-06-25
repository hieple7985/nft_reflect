module BYTES =
struct
    let to_equal (a, b : bytes * bytes) : nat =
        if a=b then 0n
        else let _ = Test.log(_fail_str ^ "Expected ", a, " to equal ", b) in 1n
end
