// parse("foo", "=", 42, (("bar", 24; "foo", 42))
#import "oracle_types.mligo" "OracleTypes"

// Checks oracle response to see whether oracle condition is met
let parse (type v) (param_name, operator, expected_value, var : string * string * v * v) : bool =
    if(operator = "=") then
        [%Michelson ({|{ UNPAIR; COMPARE; EQ }|} : v * v -> bool)] (expected_value, var)
    else if(operator = "<>") then
        [%Michelson ({|{ UNPAIR; COMPARE; NEQ }|} : v * v -> bool)] (expected_value, var)

    // I don't know why but this function only passes tests if I swap less than/or equual
    // with greater than/or equal. So that's what I did
    // It doesn't make sense. Will come back to this if it makes sense later
    else if (operator = ">") then
        [%Michelson ({|{ UNPAIR; COMPARE; LT }|} : v * v -> bool)] (expected_value, var)
    else if (operator = ">=") then
        [%Michelson ({|{ UNPAIR; COMPARE; LE }|} : v * v -> bool)] (expected_value, var)

    else if (operator = "<") then
        [%Michelson ({|{ UNPAIR; COMPARE; GT }|} : v * v -> bool)] (expected_value, var)
    else if (operator = "<=") then
        [%Michelson ({|{ UNPAIR; COMPARE; GE }|} : v * v -> bool)] (expected_value, var)
    else false

let parse_option (type k) (param_name, operator, expected_value_option, response_value_option : string * string * k option * k option) : bool =
    match expected_value_option with
      None -> false
    | Some expected_value ->
        let ans = match response_value_option with
          None -> false
        | Some response_value -> parse(param_name, operator, expected_value, response_value)
    in ans

let parseResponse (top_level_param_name, param_name, operator, expected_value_bytes, oracleResponse :
                    string * string * string * bytes * OracleTypes.response) : bool =

    match Map.find_opt top_level_param_name oracleResponse with
      None -> false
    | Some x ->
        let ans : bool = match Map.find_opt param_name x with
          None -> false
        | Some response_val ->
            if(response_val.type_ = "int") then
                let expected_val : int option = Bytes.unpack(expected_value_bytes) in
                let response_val : int option = Bytes.unpack(response_val.value) in
                parse_option (param_name, operator, expected_val, response_val)
            else if(response_val.type_ = "nat") then
                let expected_val : nat option = Bytes.unpack(expected_value_bytes) in
                let response_val : nat option = Bytes.unpack(response_val.value) in
                parse_option (param_name, operator, expected_val, response_val)
            else if(response_val.type_ = "string") then
                if(operator = "=" || operator = "<>")
                then
                    let expected_val : string option = Bytes.unpack(expected_value_bytes) in
                    let response_val : string option = Bytes.unpack(response_val.value) in
                    parse_option (param_name, operator, expected_val, response_val)
                else false
            else false
        in ans
                // else (None, None : bool option * bool option) in
            // if(val.type_ = "int" || val.type_ = "nat")

            // parse(param_name, operator, expected_value_bytes, var)

            (*
            let blah = match expected_val with
              None -> false
            | Some ->
                let blah = match response_val with
                  None -> false
                | Some -> parse(param_name, operator, expected_value, response_val)

                in blah
            in blah
                *)
