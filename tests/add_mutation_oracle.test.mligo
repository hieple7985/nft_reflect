let test_add_mutation_oracle_pass =
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

    let asserts = add_assert(asserts, 
        EXPECT.not_to_fail( Test.transfer_to_contract nft (SetOracle params: FA2.parameter) 0tez )
    ) in

    let storage = Test.get_storage nft_taddr in

    let storage_token_mutate = match Big_map.find_opt token_id storage.token_mutate with
      None -> Test.failwith "unacceptable!"
    | Some v -> v in

    let asserts = add_assert(asserts,
        EXPECT.BIG_MAP.to_have_key(token_id, storage.token_mutate)
    ) in

    let asserts = add_assert(asserts,
        EXPECT.STRING.to_equal(storage_token_mutate.oracle.params, oracle_details.params)
    ) in

    EXPECT.results asserts

let test_add_mutation_oracle_fail_if_caller_is_not_admin =
    let asserts : nat option = None in
    let token_id : FA2.token_id = 1n in

    let (nft_addr, nft_taddr, nft) = OriginateContract.nft (None: FA2.storage option) in

    let (oracle_addr, _, _) = OriginateContract.mockOracle (None: MockOracle.storage option) in

    let oracle_details : FA2.TokenMutate.oracle = {
        address = oracle_addr;
        params = "blah";
        fn_name = "data"
    } in

    let params : FA2.set_oracle = {token_id=token_id; oracle=oracle_details} in

    let asserts = add_assert(asserts, 
        EXPECT.to_fail_with( Test.transfer_to_contract nft (SetOracle params: FA2.parameter) 0tez , FA2.Errors.requires_admin)
    ) in

    EXPECT.results asserts

let test_add_mutation_oracle_fail_if_oracle_doesnt_exist =
    let asserts : nat option = None in
    let token_id : FA2.token_id = 1n in

    let (nft_storage, owners, _) = get_initial_storage(10n, 10n, 10n) in
    let admin = List_helper.nth_exn 0 owners in

    let () = Test.set_source(admin) in

    let (nft_addr, nft_taddr, nft) = OriginateContract.nft (Some(nft_storage)) in

    let oracle_details : FA2.TokenMutate.oracle = {
        address = Test.nth_bootstrap_account 2;
        params = "blah";
        fn_name = "data"
    } in

    let params : FA2.set_oracle = {token_id=token_id; oracle=oracle_details} in

    let asserts = add_assert(asserts,
        EXPECT.to_fail_with( Test.transfer_to_contract nft (SetOracle params: FA2.parameter) 0tez, FA2.Errors.bad_oracle )
    ) in

    EXPECT.results asserts

let test_add_mutation_oracle_fail_if_oracle_is_wrong_contract_type =
    let asserts : nat option = None in
    let token_id : FA2.token_id = 1n in

    let (nft_storage, owners, _) = get_initial_storage(10n, 10n, 10n) in
    let admin = List_helper.nth_exn 0 owners in

    let () = Test.set_source(admin) in

    let (nft_addr, nft_taddr, nft) = OriginateContract.nft (Some(nft_storage)) in

    let oracle_details : FA2.TokenMutate.oracle = {
        address = Test.nth_bootstrap_contract 1n;
        params = "blah";
        fn_name = "data"
    } in

    let params : FA2.set_oracle = {token_id=token_id; oracle=oracle_details} in

    let asserts = add_assert(asserts,
        EXPECT.to_fail_with( Test.transfer_to_contract nft (SetOracle params: FA2.parameter) 0tez, FA2.Errors.bad_oracle)
    ) in

    EXPECT.results asserts
