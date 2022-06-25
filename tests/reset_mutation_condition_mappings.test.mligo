let test_reset_token_mutations__pass =
    let asserts : nat option = None in
    let token_id : FA2.token_id = 1n in
    let token_data = {token_id=token_id;token_info=(Map.empty : (string, bytes) map);} in

    let (mockOracle_addr, mockOracle_taddr, mockOracle) = OriginateContract.mock_oracle(None: MockOracle.storage option) in

    let token_mutate_1n : FA2.Storage.metadata_mutate = {
        oracle = {address = mockOracle_addr; params = [("foobar", "oobar", "bar")]};
        cases = [{
                condition = {
                    top_level_param_name="japan";
                    param_name="air_quality_index";
                    operator="=";
                    value=Bytes.pack(4)
                };
                fields = [{ name = "name"; value=Bytes.pack("bladhfia") }; 
                    { name = "displayUri"; value=Bytes.pack "fajfj aoejf owjfjo wejif ifjow jf" }; 
                ]
            };
            {
                condition = {
                    top_level_param_name="japan";
                    param_name="happy_people";
                    operator=">=";
                    value=Bytes.pack(70)
                };
                fields = [{ name = "description"; value=Bytes.pack "aaifjaoe aifji oajfja" }]
            };
        ];
    } in

    let (nft_storage, owners, _) = get_initial_storage(10n, 10n, 10n) in
    let admin = List_helper.nth_exn 0 owners in

    let () = Test.set_source(admin) in

    let token_mutate_all = Big_map.add 1n token_mutate_1n nft_storage.token_mutate in
    let nft_storage = { nft_storage with token_mutate = token_mutate_all } in

    let (nft_addr, nft_taddr, nft) = OriginateContract.nft (Some(nft_storage)) in


    let params : FA2.delete_token_mutate_cases = token_id in

    let asserts = add_assert(asserts, 
        EXPECT.not_to_fail( Test.transfer_to_contract nft (DeleteMutateCases params: FA2.parameter) 0tez )
    ) in

    let storage = Test.get_storage nft_taddr in

    let asserts = add_assert(asserts,
        EXPECT.BIG_MAP.to_have_key(token_id, storage.token_mutate)
    ) in

    let storage_token_mutate = match Big_map.find_opt token_id storage.token_mutate with
      None -> Test.failwith "unacceptable!"
    | Some v -> v in

    let asserts = add_assert(asserts,
        EXPECT.LIST.to_be_empty(storage_token_mutate.cases)
    ) in

    EXPECT.results asserts

let test_add_mutation_case_fail_if_caller_is_not_admin =
    let asserts : nat option = None in
    let token_id : FA2.token_id = 1n in

    let (nft_addr, nft_taddr, nft) = OriginateContract.nft (None: FA2.storage option) in

    let params : FA2.delete_token_mutate_cases =  token_id in

    let asserts = add_assert(asserts, 
        EXPECT.to_fail_with( Test.transfer_to_contract nft (DeleteMutateCases params: FA2.parameter) 0tez, FA2.Errors.requires_admin )
    ) in

    EXPECT.results asserts
