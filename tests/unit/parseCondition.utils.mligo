#import "../../contracts/utils.parseCondition.mligo" "Parser"

let map = Map.literal[
    ("foo", 3);
    ("bar", 4)
]

let test_parse_simple_mapping_equal_to_condition_is_true =
    let fails = (None: nat option) in

    let result = Parser.parse("foo", "=", 3, map) in
    let fails = add_fail(fails, EXPECT.to_be_true(result)) in

    EXPECT.results fails

let test_parse_simple_mapping_equal_to_condition_is_false =
    let fails = (None: nat option) in
    
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", "=", 4, map))) in
    // let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", "=", 4n, map))) in

    EXPECT.results fails

let test_parse_simple_mapping_not_equal_to_condition_is_true =
    let fails = (None: nat option) in
    let foo = 3 in

    let fails = add_fail(fails, EXPECT.to_be_true(Parser.parse("foo", "<>", 4, map))) in
    let fails = add_fail(fails, EXPECT.to_be_true(Parser.parse("foo", "<>", 2, map))) in

    EXPECT.results fails

let test_parse_simple_mapping_not_equal_to_condition_is_false =
    let fails = (None: nat option) in
    let foo = 3 in

    let fails = add_fail(fails, EXPECT.to_be_false(Parser.parse("foo", "<>", 3, map))) in

    EXPECT.results fails

let test_parse_simple_mapping_less_than_condition_is_true =
    let fails = (None: nat option) in

    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parse("foo", "<", 4, map))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parse("foo", "<", 7, map))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parse("foo", "<", 5, map))) in

    EXPECT.results fails

let test_parse_simple_mapping_less_than_condition_is_false =
    let fails = (None: nat option) in
    
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", "<", 3, map))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", "<", 2, map))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", "<", 1, map))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", "<", 0, map))) in
    
    EXPECT.results fails

let test_parse_simple_mapping_less_than_or_equal_condition_is_true =
    let fails = (None: nat option) in
    let foo = 3 in

    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parse("foo", "<=", 3, map))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parse("foo", "<=", 4, map))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parse("foo", "<=", 7, map))) in

    EXPECT.results fails

let test_parse_simple_mapping_less_than_or_equal_condition_is_false =
    let fails = (None: nat option) in
    let foo = 3 in

    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", "<=", 2, map))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", "<=", 1, map))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", "<=", 0, map))) in

    EXPECT.results fails

let test_parse_simple_mapping_greater_than_condition_is_true =
    let fails = (None: nat option) in

    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parse("foo", ">", 2, map))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parse("foo", ">", 1, map))) in

    EXPECT.results fails

let test_parse_simple_mapping_greater_than_condition_is_false =
    let fails = (None: nat option) in

    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", ">", 3, map))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", ">", 4, map))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", ">", 5, map))) in

    EXPECT.results fails

let test_parse_simple_mapping_greater_than_or_equal_condition_is_true =
    let fails = (None: nat option) in

    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parse("foo", ">=", 2, map))) in
    let fails = add_fail(fails, EXPECT.to_be_true( Parser.parse("foo", ">=", 3, map))) in

    EXPECT.results fails

let test_parse_simple_mapping_greater_than_or_equal_condition_is_false =
    let fails = (None: nat option) in
    let foo=4 in

    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", ">=", 6, map))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", ">=", 5, map))) in
    let fails = add_fail(fails, EXPECT.to_be_false( Parser.parse("foo", ">=", 4, map))) in

    EXPECT.results fails
