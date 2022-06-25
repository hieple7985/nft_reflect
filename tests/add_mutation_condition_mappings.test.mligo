let test_add_mutation_pass =
    let asserts : nat option = None in
    let token_id : FA2.token_id = 10n in

    let (nft_storage, owners, _) = get_initial_storage(10n, 10n, 10n) in
    let admin = List_helper.nth_exn 0 owners in

    let () = Test.set_source(admin) in

    let (nft_addr, nft_taddr, nft) = OriginateContract.nft (Some(nft_storage)) in

    let _ = Test.transfer_to_contract nft (Create_token {token_id = token_id;
            data = {token_id=token_id;token_info=(Map.empty : (string, bytes) map)}} : FA2.parameter) 0tez in

    // Sanity check: Checking storage before adding oracle details for token mutate
    let storage = Test.get_storage nft_taddr in
    let asserts = add_assert(asserts,
        EXPECT.BIG_MAP.to_not_have_key(token_id, storage.token_mutate)
    ) in

    let (oracle_addr, _, _) = OriginateContract.mockOracle (None: MockOracle.storage option) in
    let oracle_details : FA2.TokenMutate.oracle = {
        fn_name = "data";
        address = oracle_addr;
        params = "blah";
    } in

    let params : FA2.set_oracle = {token_id=token_id; oracle=oracle_details} in

    let _ = Test.transfer_to_contract_exn nft (SetOracle params: FA2.parameter) 0tez in

    let storage = Test.get_storage nft_taddr in

    let case : FA2.TokenMutate.case = {
        condition = {
            top_level_param_name="japan";
            param_name="air_quality_index";
            operator="=";
            value=Bytes.pack(4)
        };
        fields = [{ name = "name"; value=Bytes.pack "Foo bar NFT" }; 
            { name = "displayUri"; value=Bytes.pack "https://lorem-ipsum.pixes.org/random-img.png" }; 
        ]
    } in

    let params : FA2.add_token_mutate_case = { token_id=token_id; token_mutate_case=case } in

    let asserts = add_assert(asserts, 
        EXPECT.not_to_fail( Test.transfer_to_contract nft (AddMutateCase params: FA2.parameter) 0tez )
    ) in

    let storage = Test.get_storage nft_taddr in

    let asserts = add_assert(asserts,
        EXPECT.BIG_MAP.to_have_key(token_id, storage.token_mutate)
    ) in

    let storage_token_mutate = match Big_map.find_opt token_id storage.token_mutate with
      None -> Test.failwith "unacceptable!"
    | Some v -> v in

    let asserts = add_assert(asserts,
        EXPECT.LIST.to_not_be_empty(storage_token_mutate.cases)
    ) in

    let asserts = match List.head_opt storage_token_mutate.cases with
      None -> add_fail(asserts)
    | Some token_case0 ->
        let asserts = add_assert(asserts,
            EXPECT.STRING.to_equal(token_case0.condition.top_level_param_name, case.condition.top_level_param_name)
        ) in

        let asserts = add_assert(asserts,
            EXPECT.STRING.to_equal(token_case0.condition.param_name, case.condition.param_name)
        ) in

        let asserts = add_assert(asserts,
            EXPECT.STRING.to_equal(token_case0.condition.operator, case.condition.operator)
        ) in

        let asserts = add_assert(asserts,
            EXPECT.BYTES.to_equal(token_case0.condition.value, case.condition.value)
        ) in

        let asserts = match List.head_opt token_case0.fields with
          None -> add_fail(asserts)
        | Some mutate_fields0 ->
            let asserts = add_assert(asserts,
                EXPECT.STRING.to_equal(mutate_fields0.name, "name")
            ) in 
            let asserts = add_assert(asserts,
                EXPECT.BYTES.to_equal(mutate_fields0.value, Bytes.pack "Foo bar NFT")
            ) in 

            asserts in

    (*
        let asserts = match List.tail_opt token_case0.fields with
          None -> add_assert(asserts, 1n)
        | Some mutate_fields1 ->
            let extra_fails = add_assert(asserts,
                EXPECT.STRING.to_equal(mutate_fields1.name, "description")
            ) in 
            let extra_fails = add_assert(asserts,
                EXPECT.BYTES.to_equal(mutate_fields1.value, Bytes.pack "Foo bar NFT")
            ) in 

            extra_fails in
            *)

        asserts in

    EXPECT.results asserts

let test_add_mutation_case_fail_if_caller_is_not_admin =
    let asserts : nat option = None in
    let token_id : FA2.token_id = 1n in

    let (nft_addr, nft_taddr, nft) = OriginateContract.nft (None: FA2.storage option) in

    let case : FA2.TokenMutate.case = {
        condition = {
            top_level_param_name="japan";
            param_name="air_quality_index";
            operator="=";
            value=Bytes.pack(4)
        };
        fields = [{ name = "name"; value=Bytes.pack "Foo bar NFT" }; 
            { name = "displayUri"; value=Bytes.pack "https://lorem-ipsum.pixes.org/random-img.png" }; 
        ]
    } in

    let params : FA2.add_token_mutate_case = { token_id=token_id; token_mutate_case=case } in

    let asserts = add_assert(asserts, 
        EXPECT.to_fail_with( Test.transfer_to_contract nft (AddMutateCase params: FA2.parameter) 0tez, FA2.Errors.requires_admin )
    ) in

    EXPECT.results asserts

let test_add_mutation_fail_if_oracle_not_set =
    let asserts : nat option = None in
    let token_id : FA2.token_id = 10n in

    let (nft_storage, owners, _) = get_initial_storage(10n, 10n, 10n) in
    let admin = List_helper.nth_exn 0 owners in

    let () = Test.set_source(admin) in

    let (nft_addr, nft_taddr, nft) = OriginateContract.nft (Some(nft_storage)) in

    let _ = Test.transfer_to_contract nft (Create_token {token_id = token_id;
            data = {token_id=token_id;token_info=(Map.empty : (string, bytes) map)}} : FA2.parameter) 0tez in

    // Sanity check: Checking storage before adding oracle details for token mutate
    let storage = Test.get_storage nft_taddr in
    let asserts = add_assert(asserts,
        EXPECT.BIG_MAP.to_not_have_key(token_id, storage.token_mutate)
    ) in

    let case : FA2.TokenMutate.case = {
        condition = {
            top_level_param_name="japan";
            param_name="air_quality_index";
            operator="=";
            value=Bytes.pack(4)
        };
        fields = [{ name = "name"; value=Bytes.pack "Foo bar NFT" }; 
            { name = "displayUri"; value=Bytes.pack "https://lorem-ipsum.pixes.org/random-img.png" }; 
        ]
    } in

    let params : FA2.add_token_mutate_case = { token_id=token_id; token_mutate_case=case } in

    let asserts = add_assert(asserts, 
        EXPECT.to_fail_with( Test.transfer_to_contract nft (AddMutateCase params: FA2.parameter) 0tez, FA2.Errors.set_oracle_first )
    ) in

    let storage = Test.get_storage nft_taddr in

    let asserts = add_assert(asserts,
        EXPECT.BIG_MAP.to_not_have_key(token_id, storage.token_mutate)
    ) in

    EXPECT.results asserts
