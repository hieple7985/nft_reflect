#import "../../contracts/utils.parseCondition.mligo" "Parser"
#import "../../contracts/oracle_types.mligo" "OracleTypes"

let mapping_conditions : OracleTypes.response = Map.literal[
    ("france", Map.literal[
        ("foo", 3);
        ("bar", 4)
    ])
]

let test_parse_oracle_response_equal_to_condition_is_true =
    let fails = (None: nat option) in

    let result = Parser.parseResponse("france", "foo", "=", 3, mapping_conditions) in
    let fails = add_fail(fails, EXPECT.to_be_true(result)) in

    EXPECT.results fails

let test_parse_oracle_response_equal_to_condition_is_false =
    let fails = (None: nat option) in
    
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parseResponse("france", "foo", "=", 4, mapping_conditions))) in
    // let fails = add_fail(fails, EXPECT.to_be_false( Parser.parseResponse("foo", "=", 4n, foo))) in

    EXPECT.results fails

(*
let test_parse_oracle_response_not_equal_to_condition_is_true =
    let fails = (None: nat option) in
    let foo = 3 in

    let fails = add_fail(fails, EXPECT.to_be_true(Parser.parseResponse("foo", "<>", 4, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_true(Parser.parseResponse("foo", "<>", 2, foo))) in

    EXPECT.results fails

let test_parse_oracle_response_not_equal_to_condition_is_false =
    let fails = (None: nat option) in
    let foo = 3 in

    let fails = add_fail(fails, EXPECT.to_be_false(Parser.parseResponse("foo", "<>", 3, foo))) in

    EXPECT.results fails

let test_parse_oracle_response_less_than_condition_is_true =
    let fails = (None: nat option) in
    let foo = 2 in

    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parseResponse("foo", "<", 3, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parseResponse("foo", "<", 4, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parseResponse("foo", "<", 7, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parseResponse("foo", "<", 5, foo))) in

    EXPECT.results fails

let test_parse_oracle_response_less_than_condition_is_false =
    let fails = (None: nat option) in
    let foo = 2 in
    
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parseResponse("foo", "<", 2, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parseResponse("foo", "<", 1, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parseResponse("foo", "<", 0, foo))) in
    
    EXPECT.results fails

let test_parse_oracle_response_less_than_or_equal_condition_is_true =
    let fails = (None: nat option) in
    let foo = 3 in

    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parseResponse("foo", "<=", 3, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parseResponse("foo", "<=", 4, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parseResponse("foo", "<=", 7, foo))) in

    EXPECT.results fails

let test_parse_oracle_response_less_than_or_equal_condition_is_false =
    let fails = (None: nat option) in
    let foo = 3 in

    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parseResponse("foo", "<=", 2, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parseResponse("foo", "<=", 1, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parseResponse("foo", "<=", 0, foo))) in

    EXPECT.results fails

let test_parse_oracle_response_greater_than_condition_is_true =
    let fails = (None: nat option) in
    let foo=4 in

    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parseResponse("foo", ">", 3, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parseResponse("foo", ">", 2, foo))) in

    EXPECT.results fails

let test_parse_oracle_response_greater_than_condition_is_false =
    let fails = (None: nat option) in
    let foo=4 in

    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parseResponse("foo", ">", 4, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parseResponse("foo", ">", 5, foo))) in

    EXPECT.results fails

let test_parse_oracle_response_greater_than_or_equal_condition_is_true =
    let fails = (None: nat option) in
    let foo=4 in

    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parseResponse("foo", ">=", 4, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parseResponse("foo", ">=", 3, foo))) in

    EXPECT.results fails

let test_parse_oracle_response_greater_than_or_equal_condition_is_false =
    let fails = (None: nat option) in
    let foo=4 in

    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parseResponse("foo", ">=", 6, foo))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parseResponse("foo", ">=", 5, foo))) in

    EXPECT.results fails
    *)
