let fail_str = "xx ASSERTION FAILED - "
let pass_str = "++ ASSERTION PASSED "

type str_record = { ans : string }

let print_fail (type a) (val : a) : unit =
    let _ = Test.log(fail_str, val) in ()

let tost_result (fails : nat option) : string =
  let response = match fails with
    Some v -> 
      if v > 0n
      then
        let fail_str = "************* FAILED WITH" in
        if v=1n then fail_str ^ " 1 failed assertion" ^ "**************************************************************"
        else if v=2n then fail_str ^ " 2 failed assertion" ^ "**************************************************************"
        else if v=3n then fail_str ^ " 3 failed assertion" ^ "**************************************************************"
        else fail_str ^ " more than 3 failed assertions" ^ "**************************************************************"
      else
        "PASSED"
  |  None -> "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~PENDING~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

    in response

let add_assert(init_fail, fail : nat option * nat) : nat option =
  match init_fail with
    Some v -> Some(v + fail)
  | None -> Some(0n + fail)

let add_fail(init_fail : nat option) : nat option =
  match init_fail with
    Some v -> Some(v + 1n)
  | None -> Some(1n)

let add_fail_with_message(init_fail, message : nat option * a) : nat option =
  let _ = print_fail(message) in add_fail(init_fail)
