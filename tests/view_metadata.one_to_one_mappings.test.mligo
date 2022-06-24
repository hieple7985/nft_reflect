// Tests that metadata is switched when mutation info is in one-to-one mappings
// of condition -> metadata.field = value

let test_token_metadata_one_to_one_mappings = 
    let fails : nat option = None in
    let token_id : FA2.token_id = 1n in
    let token_data = {token_id=token_id;token_info=(Map.empty : (string, bytes) map);} in
    let nft_storage, _, _ = get_initial_storage(10n, 10n, 10n) in

    let oracle_storage : MockOracle.storage = Map.literal [
        ("japan", Map.literal[
         ("air_quality_index", 4);
         ("happy_people", 72);
        ])
    ] in

    let compiler = fun(x: MockOracle.storage) -> x in
    let (mockOracle_addr, _,_) = Test.originate_from_file "tests/mock_contracts/data_oracle.mligo" "main" ["data"] (Test.run compiler oracle_storage) 0tez in
    let (mockOracle_taddr, _,_) = Test.originate MockOracle.main oracle_storage 0tez in
    let mockOracle = Test.to_contract mockOracle_taddr in

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
                    value=4
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
                    value=70
                };
                fields = [{ name = "description"; value=description }]
            };
        ];
    } in

    let token_metadata_mutate_all = Big_map.add 1n token_mutate_1n nft_storage.token_metadata_mutate in
    let nft_storage = { nft_storage with token_metadata_mutate = token_metadata_mutate_all } in

    let ii2 = fun(x : FA2_NFT.storage) -> x in
    let ii2 = Test.run ii2 nft_storage  in

    let (nft_addr, _,_) = Test.originate_from_file "contracts/nft.mligo" "main" ["token_metadata"] ii2 0tez in
    let nft_taddr : (FA2_NFT.parameter, FA2_NFT.storage)typed_address = Test.cast_address(nft_addr) in

    let (viewCaller_taddr, _, _) = Test.originate View_caller.main (Some(token_data)) 0tez in 
    let viewCaller = Test.to_contract viewCaller_taddr in

    let _ = Test.log(Test.get_storage mockOracle_taddr) in

    // let _ = Test.log("Calling view directly", MockOracle.data("boom", oracle_storage)) in

    let token_metadata_res = Test.transfer_to_contract_exn viewCaller nft_addr 0tez in

    // let fails = add_fail(fails, EXPECT.not_to_fail(token_metadata_res)) in

    let token_metadata_res = match Test.get_storage viewCaller_taddr with
        Some v -> v
        | None -> failwith("failed")
        in

    let fails = add_fail(fails,
            EXPECT.MAP.to_have_key_of_value( "description", description, token_metadata_res.token_info)
            ) in
    let fails = add_fail(fails,
            EXPECT.MAP.to_have_key_of_value( "name", name, token_metadata_res.token_info)
            ) in
    let fails = add_fail(fails,
            EXPECT.MAP.to_have_key_of_value( "displayUri", displayUri, token_metadata_res.token_info)
            ) in

    EXPECT.results fails
