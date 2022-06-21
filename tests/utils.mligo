#import "../contracts/nft.mligo" "FA2_multi_asset"
#import "./balance_of_callback_contract.mligo" "Callback"

module List_helper = struct 

  let nth_exn (type a) (i: int) (a: a list) : a =
    let rec aux (remaining: a list) (cur: int) : a =
      match remaining with 
       [] -> 
        failwith "Not found in list"
      | hd :: tl -> 
          if cur = i then 
            hd 
          else aux tl (cur + 1)
    in
    aux a 0  

end

let get_initial_storage (a, b, c : nat * nat * nat) = 
  let () = Test.reset_state 6n ([] : tez list) in

  let owner1 = Test.nth_bootstrap_account 0 in 
  let owner2 = Test.nth_bootstrap_account 1 in 
  let owner3 = Test.nth_bootstrap_account 2 in 

  let owners = [owner1; owner2; owner3] in

  let op1 = Test.nth_bootstrap_account 3 in
  let op2 = Test.nth_bootstrap_account 4 in
  let op3 = Test.nth_bootstrap_account 5 in

  let ops = [op1; op2; op3] in

  let ledger = Big_map.literal ([
    ((owner1, 1n), a);
    ((owner2, 2n), b);
    ((owner3, 3n), c);
    ((owner1, 2n), a);
  ])
  in

  let operators  = Big_map.literal ([
    ((owner1, op1), Set.literal [1n; 2n]);
    ((owner2, op1), Set.literal [2n]);
    ((owner3, op1), Set.literal [3n]);
    ((op1   , op3), Set.literal [2n]);
  ])
  in
  
  let token_info = (Map.empty: (string, bytes) map) in
  let token_metadata = (Big_map.literal [
    (1n, ({token_id=1n;token_info=(Map.empty : (string, bytes) map);} : FA2_multi_asset.TokenMetadata.data));
    (2n, ({token_id=2n;token_info=(Map.empty : (string, bytes) map);} : FA2_multi_asset.TokenMetadata.data));
    (3n, ({token_id=3n;token_info=(Map.empty : (string, bytes) map);} : FA2_multi_asset.TokenMetadata.data));
  ] : FA2_multi_asset.TokenMetadata.t) in

  let initial_storage = {
    ledger                = ledger;
    token_metadata        = token_metadata;
    operators             = operators;
    admin                 = owner1;
  } in

  initial_storage, owners, ops

let originate_nft_token_metadata (init_storage: FA2_multi_asset.storage option) : address * michelson_contract * int =
  let init_storage = match init_storage with
    Some v -> v
  | None -> let blah = get_initial_storage(10n, 10n, 10n) in blah.0 in

  let ii2 = Test.run(fun(x:FA2_multi_asset.Storage.t) -> x) init_storage in

  let new_metadata = match Big_map.find_opt 1n init_storage.token_metadata with
    Some v -> v
  | None -> (failwith("Invalid") : FA2_multi_asset.TokenMetadata.data)
  in

  let _ = Test.log("NEW METADAT", new_metadata.token_info) in

  Test.originate_from_file "contracts/nft.mligo" "main" ["token_metadata"] ii2 0tez
