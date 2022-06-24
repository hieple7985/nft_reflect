#import "expect/assertions.mligo" "EXPECT"
#import "utils.mligo" "UTILS"
#import "mock_contracts/data_oracle.mligo" "MockOracle"
#import "mock_contracts/call_counter.mligo" "CallCounter"
#import "../contracts/nft.mligo" "FA2"

(* ================================================================
 * Unit tests for contract
 *)

let add_fail = EXPECT.add_fail

module List_helper = UTILS.List_helper
let get_initial_storage = UTILS.get_initial_storage


let test_set_token_image_states =
  let fails : nat option = None in
  let token_id : FA2.token_id = 1n in

  EXPECT.results fails

let test_Token_metadata_should_return_metadata_in_storage_if_no_data_in_mutate_map = 
  let fails : nat option = None in
  let token_id : FA2.Storage.token_id = 1n in
  let init_storage, _, _ = get_initial_storage(10n, 10n, 10n) in
  let storage_t_metadata = match Big_map.find_opt 1n init_storage.token_metadata with
    Some v -> v
  | None -> failwith "token not found" in

  let displayUri =  Bytes.pack("https://fancy-token-image/1.png") in
  let name = Bytes.pack("Fancy token name") in
  let description = Bytes.pack("Fancy token description") in

  let token_info = Map.literal [
    ("name", name);
    ("description", description);
    ("displayUri", displayUri);
  ] in

  let storage_t_metadata = {
    storage_t_metadata with token_info = token_info
  } in
  let storage_t_metadata_all = Big_map.update 1n (Some(storage_t_metadata)) init_storage.token_metadata in
  // let init_storage = Big_map.update 1n (Some(storage_t_metadata)) init_storage in
  let init_storage = { init_storage with token_metadata = storage_t_metadata_all } in
  let token_id : FA2.Storage.token_id = 1n in
  // Call view [@view] token_metadata()
  let token_metadata = match FA2.token_metadata (token_id,init_storage) with
    Some v -> v
  | None -> failwith("not found")
  in

  let fails = add_fail(fails, EXPECT.MAP.to_have_key_of_value ("displayUri", displayUri, token_metadata.token_info)) in
  let fails = add_fail(fails, EXPECT.MAP.to_have_key_of_value ("displayUri", displayUri, token_metadata.token_info)) in
  let fails = add_fail(fails, EXPECT.MAP.to_have_key_of_value ("name", name, token_metadata.token_info)) in
  let fails = add_fail(fails, EXPECT.MAP.to_have_key_of_value ("description", description, token_metadata.token_info)) in

  EXPECT.results fails

(*
let test_return_token_metadata_according_to_mutate_mapping = 
  let fails : nat option = None in
  let token_id : FA2.Storage.token_id = 1n in
  let init_storage, _, _ = get_initial_storage(10n, 10n, 10n) in
  let token_metadata_mutate_all = init_storage.token_metadata_mutate in

  let name = Bytes.pack("miracle episode agent") in

  let token_mutate_1n : FA2.Storage.metadata_mutate = {
    oracles = Map.literal[
      ("oracle1", Test.nth_bootstrap_account 1)
    ];
    mutate FA2.Storage.metadata_mutate = {
      oracles=Map.literal[
        ("oracle1": = [
    ("name", Map.literal[
     ("oracle1.foo=bar", name);
     ("oracle1.foo=crumpt", Bytes.pack("compact mark continental"));
     ("oracle1.foo<>crumpt", Bytes.pack("deport penetrate matter"));
    ]);
  ]} in

  let token_metadata_mutate_all = Big_map.add 1n token_mutate_1n token_metadata_mutate_all in
  // let init_storage = Big_map.update 1n (Some(token_metadata_mutate)) init_storage in
  let init_storage = { init_storage with token_metadata_mutate = token_metadata_mutate_all } in
  // Call view [@view] token_metadata()
  let token_metadata = match FA2.token_metadata (token_id,init_storage) with
    Some v -> v
  | None -> failwith("not found")
  in

  let token_metadata = token_metadata.token_info in

  let _ = Test.log("CALLED IT LIKE A FUNCTION", token_metadata) in
  
  let fails = add_fail(fails,
      EXPECT.MAP.to_have_key_of_value ("name", name, token_metadata)
  ) in

  EXPECT.results fails
  *)
