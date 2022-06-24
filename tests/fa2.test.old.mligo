#import "expect/assertions.mligo" "EXPECT"
#import "../contracts/nft.mligo" "FA2"
#import "../contracts/nft.mligo" "FA2_NFT"
#import "mock_contracts/view_caller.mligo" "View_caller"
#import "mock_contracts/call_counter.mligo" "CallCounter"

let add_fail = EXPECT.add_fail

let test_Token_metadata_should_return_metadata_in_storage_if_no_data_in_mutate_map_integ = 
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
  let _ = Test.log("ADDRESS", nft_addr) in
  let nft_taddr : (FA2_NFT.parameter, FA2_NFT.storage)typed_address = Test.cast_address(nft_addr) in
  let nft = Test.to_contract nft_taddr in
  let nft_addr = Tezos.address(nft) in
  let _ = Test.log("ADDRESS", nft_addr) in

  let token_data : FA2.TokenMetadata.data = {token_id=token_id;token_info=(Map.empty : (string, bytes) map);} in
  let (viewCaller_taddr, _, _) = Test.originate View_caller.main (Some(token_data)) 0tez in 
  let viewCaller = Test.to_contract viewCaller_taddr in
  let viewCaller_addr = Tezos.address(viewCaller) in

  let _ = Test.log("VIEW CALLER STORAGE BEFORE VIEW CALL", Test.get_storage viewCaller_taddr) in

  // let token_metadata_res = Test.transfer viewCaller_addr (Test.eval nft_addr) 0tez in
  let token_metadata_res = Test.transfer_to_contract_exn viewCaller nft_addr 0tez in
  // let token_metadata_res = Test.transfer_to_contract_exn viewCaller nft_addr 0tez in
  let _ = Test.log("NFT addr:", nft_addr) in

  let _ = Test.log("VIEW CALLER STORAGE AFTER VIEW CALL", Test.get_storage viewCaller_taddr) in

(*
  let storage = match Test.get_storage viewCaller_taddr with
    Some v -> v
    | None -> failwith("failed")
  in
  *)


  EXPECT.results fails

(*
let test_token_metadata_one_to_one_mappings = 
  let fails : nat option = None in
  let token_id : FA2.token_id = 1n in
  let token_data = {token_id=token_id;token_info=(Map.empty : (string, bytes) map);} in
  let nft_storage, _, _ = get_initial_storage(10n, 10n, 10n) in

  let (mockOracle_taddr, _,_) = Test.originate CallCounter.main (None: CallCounter.storage option) 0tez in
  let mockOracle = Test.to_contract mockOracle_taddr in
  let mockOracle_addr = Tezos.address(mockOracle) in

  let token_mutate_1n : FA2.Storage.metadata_mutate = {
    oracle = {address = mockOracle_addr; params = "foobar"; fn_name="blah"};
    conditions = [{
      // oracle="oracle1";
      condition = "foo=bar";
      fields = [{ name = "name"; value="fancy_name_1" }]
    }];
  } in

  let token_metadata_mutate_all = Big_map.add 1n token_mutate_1n nft_storage.token_metadata_mutate in
  let nft_storage = { nft_storage with token_metadata_mutate = token_metadata_mutate_all } in

  let ii2 = fun(x : FA2_NFT.storage) -> x in
  let ii2 = Test.run ii2 nft_storage  in

  let (nft_addr, _,_) = Test.originate_from_file "contracts/nft.mligo" "main" ["token_metadata"] ii2 0tez in
  let nft_taddr : (FA2_NFT.parameter, FA2_NFT.storage)typed_address = Test.cast_address(nft_addr) in
  // let nft_token_metadata : (FA2_NFT.token_id) contract = Test.to_entrypoint "token_metadata" nft_taddr in

  let (viewCaller_taddr, _, _) = Test.originate View_caller.main (Some(token_data)) 0tez in 
  let viewCaller = Test.to_contract viewCaller_taddr in

(*
  let token_metadata_res = Test.transfer_to_contract_exn viewCaller nft_addr 0tez in

  let storage = match Test.get_storage viewCaller_taddr with
    Some v -> v
    | None -> failwith("failed")
  in

  let fails = add_fail(fails, EXPECT.to_equal(storage.token_id, token_id)) in

  let _ = Test.log token_metadata_res in

  // let fails = add_fails(fails, EXPECT.not_to_fail token_metadata_res) in
  // let fails = add_fails(fails, EXPECT.to_ token_metadata_res) in
*)

  EXPECT.results fails
*)

