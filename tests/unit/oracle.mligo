#import "../../contracts/oracle.mligo" "Oracle"

let test_oracle_view_empty_response_when_keys_not_found =
    let asserts = (None: nat option) in

    let japan_airq = {value=Bytes.pack(4); type_="int"} in
    let japan_happy = {value=Bytes.pack(72); type_="int"} in

    let oracle_storage : Oracle.storage = Big_map.literal [
        ("WHO", Map.literal[
            ("countries", Map.literal[
                ("japan", Map.literal[
                    ("air_quality_index", {value=Bytes.pack(4); type_="int"});
                    ("happy_people", {value=Bytes.pack(72); type_="int"});
                ])
            ])
        ])
    ] in

    let data_key = "WHO-countries-japan" in

    let response:Oracle.response = Oracle.data([("NOT_WHO", "countries", "hongkong")], oracle_storage) in
    let asserts = add_assert(asserts, EXPECT.MAP.to_be_empty(response)) in

    let response:Oracle.response = Oracle.data([("WHO", "jobs_by_country", "hongkong")], oracle_storage) in
    let asserts = add_assert(asserts, EXPECT.MAP.to_be_empty(response)) in

    let response:Oracle.response = Oracle.data([("WHO", "countries", "hongkong")], oracle_storage) in
    let asserts = add_assert(asserts, EXPECT.MAP.to_be_empty(response)) in

    EXPECT.results asserts


let test_oracle_view_return =
    let asserts = (None: nat option) in

    let japan_airq = {value=Bytes.pack(4); type_="int"} in
    let japan_happy = {value=Bytes.pack(72); type_="int"} in

    let oracle_storage : Oracle.storage = Big_map.literal [
        ("WHO", Map.literal[
            ("countries", Map.literal[
                ("japan", Map.literal[
                    ("air_quality_index", {value=Bytes.pack(4); type_="int"});
                    ("happy_people", {value=Bytes.pack(72); type_="int"});
                ])
            ])
        ])
    ] in

    let data_key = "WHO-countries-japan" in

    let response:Oracle.response = Oracle.data([("WHO", "countries", "japan")], oracle_storage) in

    let asserts = add_assert(asserts,
        EXPECT.MAP.to_have_key( data_key, response)
    ) in

    let asserts = match Map.find_opt data_key response with
      None -> add_fail(asserts)
    | Some v ->
        let asserts = add_assert(asserts,
            EXPECT.MAP.to_have_key_with_value("air_quality_index", japan_airq, v)
        ) in

        add_assert(asserts,
            EXPECT.MAP.to_have_key_with_value("happy_people", japan_happy, v)
        ) in

    EXPECT.results asserts

let test_oracle_view_get_multiple_responses_from_oracle =
    let asserts = (None: nat option) in

    let oracle_storage : Oracle.storage = Big_map.literal [
        ("WHO", Map.literal[
            ("countries", Map.literal[
                ("japan", Map.literal[
                    ("air_quality_index", {value=Bytes.pack(4); type_="int"});
                    ("happy_people", {value=Bytes.pack(72); type_="int"});
                ]);
                ("france", Map.literal[
                    ("air_quality_index", {value=Bytes.pack(4); type_="int"});
                    ("happy_people", {value=Bytes.pack(72); type_="int"});
                ])
            ])
        ])
    ] in

    type expected_response = {key: string;
        airq: {value: bytes; type_: string};
        happy: {value: bytes; type_: string};
    } in

    let data_keys : expected_response list = [
       {key="WHO-countries-japan"; airq={value=Bytes.pack(4); type_="int"}; happy={value=Bytes.pack(72); type_="int"}};
       {key= "WHO-countries-france"; airq = {value=Bytes.pack(4); type_="int"}; happy = {value=Bytes.pack(72); type_="int"}}
    ] in

    let response:Oracle.response = Oracle.data([
        ("WHO", "countries", "japan");
        ("WHO", "countries", "france")
    ], oracle_storage) in

    let new_asserts = 0n in

    let assert_responses = fun (assert_acc, expected_response : nat * expected_response) -> 
        let data_key = expected_response.key in
        let airq = expected_response.airq in
        let happy = expected_response.happy in
        let assert_acc = assert_acc + EXPECT.MAP.to_have_key( data_key, response) in
        let assert_acc = match Map.find_opt data_key response with
          None -> 1n
        | Some v ->
            let assert_acc = assert_acc + EXPECT.MAP.to_have_key_with_value("air_quality_index", airq, v) in
            let assert_acc = assert_acc + EXPECT.MAP.to_have_key_with_value("happy_people", happy, v) in
            assert_acc in
        assert_acc in

    let asserts = add_assert(asserts,
        List.fold_left assert_responses new_asserts data_keys
    ) in

    EXPECT.results asserts
