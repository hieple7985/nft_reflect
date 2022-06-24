// parse("foo", "=", 42, (("bar", 24; "foo", 42))
#import "oracle_types.mligo" "OracleTypes"

// Checks oracle response to see whether oracle condition is met
let parse (type v) (param_name, operator, value, map : string * string * v * (string, v)map) : bool =
    match Map.find_opt param_name map with
        None -> false
        | Some var -> 
            if(operator = "=") then
                [%Michelson ({|{ UNPAIR; COMPARE; EQ }|} : v * v -> bool)] (value, var)
            else if(operator = "<>") then
                [%Michelson ({|{ UNPAIR; COMPARE; NEQ }|} : v * v -> bool)] (value, var)

            // I don't know why but this function only passes tests if I swap less than/or equual
            // with greater than/or equal. So that's what I did
            // It doesn't make sense. Will come back to this if it makes sense later
            else if (operator = ">") then
                [%Michelson ({|{ UNPAIR; COMPARE; LT }|} : v * v -> bool)] (value, var)
            else if (operator = ">=") then
                [%Michelson ({|{ UNPAIR; COMPARE; LE }|} : v * v -> bool)] (value, var)

            else if (operator = "<") then
                [%Michelson ({|{ UNPAIR; COMPARE; GT }|} : v * v -> bool)] (value, var)
            else if (operator = "<=") then
                [%Michelson ({|{ UNPAIR; COMPARE; GE }|} : v * v -> bool)] (value, var)
            else false

let parseResponse (top_level_param_name, param_name, operator, value, oracleResponse : string * string * string * int * OracleTypes.response) : bool =
    match Map.find_opt top_level_param_name oracleResponse with
        None -> false
        | Some var -> parse(param_name, operator, value, var)
