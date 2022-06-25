#import "../../contracts/utils.parseCondition.mligo" "Parser"
#import "../../contracts/oracle_types.mligo" "OracleTypes"

let mapping_conditions : OracleTypes.response = Map.literal[
    ("france", Map.literal[
        ("foo", {value = Bytes.pack(3); type_ = "int"});
        ("bar", {value = Bytes.pack("intrepid"); type_ = "string"});
        ("boo", {value = Bytes.pack(3n); type_ = "nat"});
    ])
]

let test_condition_on_oracle_response_equal_to_condition_is_true =
    let asserts = (None: nat option) in
    let val = Bytes.pack(3) in

    // let result : bool = Parser.parseResponse("france", "foo", "=", val, mapping_conditions) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "foo", "=", Bytes.pack(3), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "boo", "=", Bytes.pack(3n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "bar", "=", Bytes.pack("intrepid"), mapping_conditions))) in

    EXPECT.results asserts

let test_condition_on_oracle_response_equal_to_condition_is_false =
    let asserts = (None: nat option) in
    
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "foo", "=", Bytes.pack(4), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "boo", "=", Bytes.pack(4n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", "=", Bytes.pack("not intrepid"), mapping_conditions))) in

    EXPECT.results asserts

let test_condition_on_oracle_response_not_equal_to_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true(Parser.parseResponse("france", "foo", "<>", Bytes.pack(4), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true(Parser.parseResponse("france", "foo", "<>", Bytes.pack(2), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true(Parser.parseResponse("france", "boo", "<>", Bytes.pack(4n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true(Parser.parseResponse("france", "boo", "<>", Bytes.pack(2n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true(Parser.parseResponse("france", "bar", "<>", Bytes.pack("not intrepid"), mapping_conditions))) in

    EXPECT.results asserts

let test_condition_on_oracle_response_not_equal_to_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "foo", "<>", Bytes.pack(4), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "boo", "<>", Bytes.pack(4n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "bar", "<>", Bytes.pack("not intrepid"), mapping_conditions))) in

    EXPECT.results asserts

let test_condition_on_oracle_response_less_than_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "foo", "<", Bytes.pack(4), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "boo", "<", Bytes.pack(4n), mapping_conditions))) in

    EXPECT.results asserts

let test_condition_on_oracle_response_ops_other_than_eq_neq_always_false_for_strings =
    let asserts = (None: nat option) in

    // Less than
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", "<", Bytes.pack("egg"), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", "<", Bytes.pack("intrepid"), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", "<", Bytes.pack("not intrepid"), mapping_conditions))) in

    // Less than or equal to
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", "<=", Bytes.pack("egg"), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", "<=", Bytes.pack("intrepid"), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", "<=", Bytes.pack("not intrepid"), mapping_conditions))) in

    // Greater than
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", ">", Bytes.pack("egg"), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", ">", Bytes.pack("intrepid"), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", ">", Bytes.pack("not intrepid"), mapping_conditions))) in

    // Greater than or equal to
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", ">=", Bytes.pack("egg"), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", ">=", Bytes.pack("intrepid"), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "bar", ">=", Bytes.pack("not intrepid"), mapping_conditions))) in

    EXPECT.results asserts

let test_condition_on_oracle_response_when_less_than_is_false =
    let asserts = (None: nat option) in
    
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "foo", "<", Bytes.pack(2), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "boo", "<", Bytes.pack(2n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "foo", "<", Bytes.pack(1), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "boo", "<", Bytes.pack(1n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "foo", "<", Bytes.pack(0), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "boo", "<", Bytes.pack(0n), mapping_conditions))) in
    
    EXPECT.results asserts

let test_condition_on_oracle_response_less_than_or_equal_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "foo", "<=", Bytes.pack(3), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "boo", "<=", Bytes.pack(3n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "foo", "<=", Bytes.pack(4), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "boo", "<=", Bytes.pack(4n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "foo", "<=", Bytes.pack(7), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "boo", "<=", Bytes.pack(7n), mapping_conditions))) in

    EXPECT.results asserts

let test_condition_on_oracle_response_less_than_or_equal_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "foo", "<=", Bytes.pack(2), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "boo", "<=", Bytes.pack(2n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "foo", "<=", Bytes.pack(1), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "boo", "<=", Bytes.pack(1n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "foo", "<=", Bytes.pack(0), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "boo", "<=", Bytes.pack(0n), mapping_conditions))) in

    EXPECT.results asserts

let test_condition_on_oracle_response_greater_than_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "foo", ">", Bytes.pack(1), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "boo", ">", Bytes.pack(1n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "foo", ">", Bytes.pack(2), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "boo", ">", Bytes.pack(2n), mapping_conditions))) in

    EXPECT.results asserts

let test_condition_on_oracle_response_greater_than_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "foo", ">", Bytes.pack(4), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "boo", ">", Bytes.pack(4n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "foo", ">", Bytes.pack(5), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "boo", ">", Bytes.pack(5n), mapping_conditions))) in

    EXPECT.results asserts

let test_condition_on_oracle_response_greater_than_or_equal_condition_is_true =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "foo", ">=", Bytes.pack(2), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "boo", ">=", Bytes.pack(2n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "foo", ">=", Bytes.pack(3), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_true( Parser.parseResponse("france", "boo", ">=", Bytes.pack(3n), mapping_conditions))) in

    EXPECT.results asserts

let test_condition_on_oracle_response_greater_than_or_equal_condition_is_false =
    let asserts = (None: nat option) in

    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "foo", ">=", Bytes.pack(6), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "boo", ">=", Bytes.pack(6n), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "foo", ">=", Bytes.pack(5), mapping_conditions))) in
    let asserts = add_assert(asserts, EXPECT.to_be_false( Parser.parseResponse("france", "boo", ">=", Bytes.pack(5n), mapping_conditions))) in

    EXPECT.results asserts
