let test_insert_org_level_data_to_oracle =
    let asserts = (None: nat option) in
    let (_, oracle_taddr, oracle) = OriginateContract.oracle (None: Oracle.storage option) in

    let org_name = "WHO" in

    let asserts = add_assert(asserts,
        EXPECT.BIG_MAP.to_not_have_key(org_name, Test.get_storage oracle_taddr )
    ) in

    let org_data : Oracle.org_data = Map.literal[
        ("countries", Map.literal[
            ("japan", Map.literal[
                ("air_quality_index", {value=Bytes.pack(4); type_="int"});
                ("happy_people", {value=Bytes.pack(72); type_="int"});
            ])
        ])
    ] in

    let storage = Test.get_storage oracle_taddr in
    let _ = Test.log( storage ) in

    let param : Oracle.parameter = Set_org_data (org_name, org_data) in

    let asserts = add_assert(asserts,
        EXPECT.not_to_fail( Test.transfer_to_contract oracle param 0tez )
    ) in

    let asserts = add_assert(asserts,
        EXPECT.BIG_MAP.to_have_key(org_name, Test.get_storage oracle_taddr )
    ) in

    EXPECT.results asserts

