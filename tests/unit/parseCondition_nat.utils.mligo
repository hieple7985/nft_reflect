#import "../../contracts/utils.parseCondition.mligo" "Parser"

let foo = 3n

let test_parse_simple_mapping_nat_equal_to_condition_is_true =
    let asserts = (None: nat option) in

    let result = Parser.parse("foo", "=", 3n, foo) in
    let asserts = add_assert(asserts, EXPECT.to_be_true(result)) in

    EXPECT.results asserts

let test_parse_simple_mapping_nat_equal_to_condition_is_false =
    let asserts = (None: nat option) in
    
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "=", 4n, foo))) in
    // let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "=", 4n, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_nat_not_equal_to_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true(Parser.parse("foo", "<>", 4n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true(Parser.parse("foo", "<>", 2n, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_nat_not_equal_to_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_false(Parser.parse("foo", "<>", 3n, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_nat_less_than_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", "<", 4n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", "<", 7n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", "<", 5n, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_nat_less_than_condition_is_false =
    let asserts = (None: nat option) in
    
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<", 3n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<", 2n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<", 1n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<", 0n, foo))) in
    
    EXPECT.results asserts

let test_parse_simple_mapping_nat_less_than_or_equal_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", "<=", 3n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", "<=", 4n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", "<=", 7n, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_nat_less_than_or_equal_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<=", 2n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<=", 1n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "<=", 0n, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_nat_greater_than_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", ">", 2n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", ">", 1n, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_nat_greater_than_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", ">", 3n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", ">", 4n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", ">", 5n, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_nat_greater_than_or_equal_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", ">=", 2n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parse("foo", ">=", 3n, foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_nat_greater_than_or_equal_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", ">=", 6n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", ">=", 5n, foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", ">=", 4n, foo))) in

    EXPECT.results asserts
