#import "../contracts/nft.mligo" "FA2"
#import "expect/assertions.mligo" "EXPECT"
#import "utils.mligo" "UTILS"
#import "mock_contracts/data_oracle.mligo" "MockOracle"

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
  let token_metadata = match FA2.token_metadata (token_id,init_storage) with
    Some v -> v
  | None -> failwith("not found")
  in

  let fails = add_fail(fails, EXPECT.MAP.to_have_key_of_value ("displayUri", token_metadata.token_info, displayUri)) in
  let fails = add_fail(fails, EXPECT.MAP.to_have_key_of_value ("name", token_metadata.token_info, name)) in
  let fails = add_fail(fails, EXPECT.MAP.to_have_key_of_value ("description", token_metadata.token_info, description)) in

  EXPECT.results fails

let test_Token_metadata_should_change_token_name_if_name_mutate_available = 
  let fails : nat option = None in
  let init_storage, _, _ = get_initial_storage(10n, 10n, 10n) in
  let storage_t_metadata = init_storage.token_metadata in
  // let storage_t_metadata = Map.update 1n {
  let _ = Test.log(storage_t_metadata) in
  let token_id : FA2.Storage.token_id = 2n in
  let token_metadata = match FA2.token_metadata (token_id,init_storage) with
    Some v -> v
  | None -> failwith("not found")
  in

  // let _ = Test.log("CALLED IT LIKE A FUNCTION", token_metadata) in
  
  let fails = add_fail(fails,
      EXPECT.MAP.to_have_key ("displayUri", token_metadata.token_info)
  ) in

  EXPECT.results fails
