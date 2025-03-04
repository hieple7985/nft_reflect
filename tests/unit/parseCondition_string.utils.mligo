#import "../../contracts/utils.parseCondition.mligo" "Parser"

let foo = "intrepid"

let test_parse_simple_mapping_string_equal_to_condition_is_true =
    let asserts = (None: nat option) in

    let result = Parser.parse("foo", "=", "intrepid", foo) in
    let asserts = add_assert(asserts, EXPECT.to_be_true(result)) in

    EXPECT.results asserts

let test_parse_simple_mapping_string_equal_to_condition_is_false =
    let asserts = (None: nat option) in
    
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parse("foo", "=", "not intrepid", foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_string_not_equal_to_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true(Parser.parse("foo", "<>", "still not intrepid", foo))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true(Parser.parse("foo", "<>", "trolololol!", foo))) in

    EXPECT.results asserts

let test_parse_simple_mapping_string_not_equal_to_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_false(Parser.parse("foo", "<>", "intrepid", foo))) in

    EXPECT.results asserts
