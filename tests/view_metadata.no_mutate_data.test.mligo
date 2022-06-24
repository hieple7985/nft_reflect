let test_Token_metadata_should_return_metadata_in_storage_if_no_mutate = 
    let fails : nat option = None in
    let init_storage, _, _ = get_initial_storage(10n, 10n, 10n) in

    let storage_t_metadata = match Big_map.find_opt 1n init_storage.token_metadata with
    Some v -> v
    | None -> failwith "token not found" in

    let token_id : FA2.Storage.token_id = 1n in
    let displayUri =  Bytes.pack("https://fancy-token-image/1.png") in
    let name = Bytes.pack("Fancy token name") in
    let description = Bytes.pack("Fancy token description") in

    let token_info = Map.literal [
        ("name", name);
        ("description", description);
        ("displayUri", displayUri);
    ] in

    let token_metadata = {
        storage_t_metadata with token_info = token_info
    } in
    let token_metadata = Big_map.update 1n (Some(token_metadata)) init_storage.token_metadata in
    // let init_storage = Big_map.update 1n (Some(storage_t_metadata)) init_storage in
    let init_storage = { init_storage with token_metadata = token_metadata } in

    let ii2 = fun(x : FA2_NFT.storage) -> x in
    let ii2 = Test.run ii2 init_storage  in

    let (nft_addr, _,_) = Test.originate_from_file "contracts/nft.mligo" "main" (["token_metadata"] : string list) ii2 0tez in

    let token_id = 1n in
    let token_data : FA2.TokenMetadata.data = {token_id=token_id;token_info=(Map.empty : (string, bytes) map);} in

    let (viewCaller_taddr, viewCaller_code, _) = Test.originate View_caller.main (Some(token_data)) 0tez in 
    let viewCaller = Test.to_contract viewCaller_taddr in

    let token_metadata_res = Test.transfer_to_contract_exn viewCaller nft_addr 0tez in

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
