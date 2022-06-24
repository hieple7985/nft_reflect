let test_token_metadata_case_when_oracle_fails = 
    let fails : nat option = None in
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

    let oracle_storage : MockOracleError.storage = Map.literal [
        ("france", Map.literal[
         ("air_quality_index", {value=Bytes.pack(4); type_="int"});
         ("happy_people", {value=Bytes.pack(72); type_="int"});
        ])
    ] in

    let (mockOracle_taddr, _,_) = Test.originate MockOracleError.main oracle_storage 0tez in
    let mockOracle = Test.to_contract mockOracle_taddr in
    let mockOracle_addr = Tezos.address(mockOracle) in

    let token_mutate_1n : FA2.Storage.metadata_mutate = {
        oracle = {address = mockOracle_addr; params = "foobar"; fn_name="blah"};
        cases = [{
            condition = {
                top_level_param_name="france";
                param_name="foo";
                operator="=";
                value=Bytes.pack(3)
            };
            fields = [{ name = "name"; value=Bytes.pack "fancy_name_1" }]
        }];
    } in

    let token_metadata_mutate_all = Big_map.add 1n token_mutate_1n nft_storage.token_metadata_mutate in
    let nft_storage = { nft_storage with token_metadata_mutate = token_metadata_mutate_all } in

    let ii2 = fun(x : FA2_NFT.storage) -> x in
    let ii2 = Test.run ii2 nft_storage  in

    let (nft_addr, _,_) = Test.originate_from_file "contracts/nft.mligo" "main" ["token_metadata"] ii2 0tez in

    let (viewCaller_taddr, _, _) = Test.originate View_caller.main (Some(token_data)) 0tez in 
    let viewCaller = Test.to_contract viewCaller_taddr in

    let token_metadata_res = Test.transfer_to_contract viewCaller nft_addr 0tez in

    let fails = add_fail(fails, EXPECT.not_to_fail(token_metadata_res)) in

    let token_metadata_res = match Test.get_storage viewCaller_taddr with
        Some v -> v
        | None -> failwith("failed")
        in

    let fails = add_fail(fails,
            EXPECT.MAP.to_have_key_of_value( "description", old_desc, token_metadata_res.token_info)
            ) in
    let fails = add_fail(fails,
            EXPECT.MAP.to_have_key_of_value( "name", old_name, token_metadata_res.token_info)
            ) in
    let fails = add_fail(fails,
            EXPECT.MAP.to_have_key_of_value( "displayUri", old_uri, token_metadata_res.token_info)
            ) in

    EXPECT.results fails

