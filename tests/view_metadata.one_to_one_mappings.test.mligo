// Tests that metadata is switched when mutation info is in one-to-one mappings
// of condition -> metadata.field = value

let test_token_metadata_one_to_one_mappings = 
    let asserts : nat option = None in
    let token_id : FA2.token_id = 1n in
    let token_data = {token_id=token_id;token_info=(Map.empty : (string, bytes) map);} in
    let nft_storage, _, _ = get_initial_storage(10n, 10n, 10n) in

    let oracle_storage : MockOracle.storage = Map.literal [
        ("japan", Map.literal[
         ("air_quality_index", {value=Bytes.pack(4); type_="int"});
         ("happy_people", {value=Bytes.pack(72); type_="int"});
        ])
    ] in

    let (mockOracle_addr, mockOracle_taddr, mockOracle) = OriginateContract.mock_oracle(Some(oracle_storage)) in

    let name = Bytes.pack("Name on condition 1") in
    let description = Bytes.pack("Don't Count Your Chickens Before They Hatch\nMeaning: Do not rely on something you are not sure of.") in
    let displayUri = Bytes.pack("https://images.random/image/on_condition_1") in

    let token_mutate_1n : FA2.Storage.metadata_mutate = {
        oracle = {address = mockOracle_addr; params = "foobar"; fn_name="blah"};
        cases = [{
                condition = {
                    top_level_param_name="japan";
                    param_name="air_quality_index";
                    operator="=";
                    value=Bytes.pack(4)
                };
                fields = [{ name = "name"; value=name }; 
                    { name = "displayUri"; value=displayUri }; 
                ]
            };
            {
                condition = {
                    top_level_param_name="japan";
                    param_name="happy_people";
                    operator=">=";
                    value=Bytes.pack(70)
                };
                fields = [{ name = "description"; value=description }]
            };
        ];
    } in

    let token_mutate_all = Big_map.add 1n token_mutate_1n nft_storage.token_mutate in
    let nft_storage = { nft_storage with token_mutate = token_mutate_all } in

    let (nft_addr, nft_taddr, _) = OriginateContract.nft(Some(nft_storage)) in

    let (viewCaller_taddr, _, _) = Test.originate View_caller.main (Some(token_data)) 0tez in 
    let viewCaller = Test.to_contract viewCaller_taddr in

    let token_metadata_res = Test.transfer_to_contract_exn viewCaller nft_addr 0tez in

    let token_metadata_res = match Test.get_storage viewCaller_taddr with
        Some v -> v
        | None -> failwith("failed")
        in

    let asserts = add_assert(asserts,
            EXPECT.MAP.to_have_key_of_value( "description", description, token_metadata_res.token_info)
            ) in
    let asserts = add_assert(asserts,
            EXPECT.MAP.to_have_key_of_value( "name", name, token_metadata_res.token_info)
            ) in
    let asserts = add_assert(asserts,
            EXPECT.MAP.to_have_key_of_value( "displayUri", displayUri, token_metadata_res.token_info)
            ) in

    EXPECT.results asserts

let test_token_metadata_case_when_mutates_false = 
    let asserts : nat option = None in
    let token_id : FA2.token_id = 1n in
    let old_name = Bytes.pack("The default name for token") in
    let old_desc = Bytes.pack("The default description for this token") in
    let old_uri = Bytes.pack("https://images.com/default_token_image") in

    let token_data = {token_id=token_id;token_info=Map.literal[
        ("name", old_name);
        ("description", old_desc);
        ("displayUri", old_uri);
    ]} in

    let nft_storage, _, _ = get_initial_storage(10n, 10n, 10n) in

    let token_metadata = Big_map.update 1n (Some(token_data)) nft_storage.token_metadata in

    let nft_storage = { nft_storage with token_metadata = token_metadata } in

    let oracle_storage : MockOracle.storage = Map.literal [
        ("france", Map.literal[
         ("air_quality_index", {value=Bytes.pack(4); type_="int"});
         ("happy_people", {value=Bytes.pack(72); type_="int"});
        ])
    ] in

    let (mockOracle_addr, mockOracle_taddr, mockOracle) = OriginateContract.mock_oracle(Some(oracle_storage)) in

    let token_mutate_1n : FA2.Storage.metadata_mutate = {
        oracle = {address = mockOracle_addr; params = "foobar"; fn_name="blah"};
        cases = [{
            condition = {
                top_level_param_name="france";
                param_name="foo";
                operator="=";
                value=Bytes.pack(3)
            };
            fields = [
            { name = "name"; value=Bytes.pack "New Fancy Name here" };
            { name = "description"; value=Bytes.pack "fancy new description_1" };
            { name = "displayUri"; value=Bytes.pack "https://blah-images.com/blah.png" };
            ]
        }];
    } in

    let token_mutate_all = Big_map.add 1n token_mutate_1n nft_storage.token_mutate in
    let nft_storage = { nft_storage with token_mutate = token_mutate_all } in

    let (nft_addr, nft_taddr, _) = OriginateContract.nft(Some(nft_storage)) in

    let (viewCaller_taddr, _, _) = Test.originate View_caller.main (Some(token_data)) 0tez in 
    let viewCaller = Test.to_contract viewCaller_taddr in

    let token_metadata_res = Test.transfer_to_contract viewCaller nft_addr 0tez in

    let asserts = add_assert(asserts, EXPECT.not_to_fail(token_metadata_res)) in

    let token_metadata_res = match Test.get_storage viewCaller_taddr with
        Some v -> v
        | None -> failwith("failed")
        in

    let asserts = add_assert(asserts,
            EXPECT.MAP.to_have_key_of_value( "description", old_desc, token_metadata_res.token_info)
            ) in
    let asserts = add_assert(asserts,
            EXPECT.MAP.to_have_key_of_value( "name", old_name, token_metadata_res.token_info)
            ) in
    let asserts = add_assert(asserts,
            EXPECT.MAP.to_have_key_of_value( "displayUri", old_uri, token_metadata_res.token_info)
            ) in

    EXPECT.results asserts

