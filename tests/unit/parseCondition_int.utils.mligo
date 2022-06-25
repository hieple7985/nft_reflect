#import "../../contracts/utils.parseCondition.mligo" "Parser"

let foo = 3

let test_parse_simple_mapping_int_equal_to_condition_is_true =
    let asserts = (None: nat option) in

    let result = Parser.parse("foo", "=", 3, foo) in
    let asserts = add_assert(asserts, EXPECT.to_be_true(result)) in

    EXPECT.results asserts

let test_parse_simple_mapping_int_equal_to_condition_is_false =
    let asserts = (None: nat option) in
    
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "=", 4, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse_option("foo", "=", (Some(4)), (Some(foo))))) in
    // let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "=", 4n, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_int_not_equal_to_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true(Parser.parse("foo", "<>", 4, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true(Parser.parse("foo", "<>", 2, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_int_not_equal_to_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_false(Parser.parse("foo", "<>", 3, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_int_less_than_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", "<", 4, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", "<", 7, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", "<", 5, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_int_less_than_condition_is_false =
    let asserts = (None: nat option) in
    
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<", 3, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<", 2, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<", 1, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<", 0, foo))) in
    
    EXPECT.results asserts

let test_parse_simple_mapping_int_less_than_or_equal_condition_is_true =
    let asserts = (None: nat option) in
    let foo = 3 in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", "<=", 3, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", "<=", 4, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", "<=", 7, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_int_less_than_or_equal_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<=", 2, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<=", 1, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<=", 0, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_int_greater_than_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", ">", 2, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", ">", 1, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_int_greater_than_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", ">", 3, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", ">", 4, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", ">", 5, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_int_greater_than_or_equal_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", ">=", 2, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", ">=", 3, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_int_greater_than_or_equal_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", ">=", 6, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", ">=", 5, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", ">=", 4, foo))) in

    EXPECT.results asserts
