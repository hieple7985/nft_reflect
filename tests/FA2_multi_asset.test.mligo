#import "../contracts/nft.mligo" "FA2_multi_asset"
#import "./balance_of_callback_contract.mligo" "Callback"
#import "utils.mligo" "UTILS"

(* Tests for FA2 multi asset contract *)

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

let get_initial_storage = UTILS.get_initial_storage

let assert_balances 
  (contract_address : (FA2_multi_asset.parameter, FA2_multi_asset.storage) typed_address ) 
  (a, b, c : (address * nat * nat) * (address * nat * nat) * (address * nat * nat)) = 
  let (owner1, token_id_1, balance1) = a in
  let (owner2, token_id_2, balance2) = b in
  let (owner3, token_id_3, balance3) = c in
  let storage = Test.get_storage contract_address in
  let ledger = storage.ledger in
  let () = match (Big_map.find_opt (owner1, token_id_1) ledger) with
    Some amt -> assert (amt = balance1)
  | None -> failwith "incorret address" 
  in
  let () = match (Big_map.find_opt (owner2, token_id_2) ledger) with
    Some amt ->  assert (amt = balance2)
  | None -> failwith "incorret address" 
  in
  let () = match (Big_map.find_opt (owner3, token_id_3) ledger) with
    Some amt -> assert (amt = balance3)
  | None -> failwith "incorret address" 
  in
  ()


(* Transfer *)

(* 1. transfer successful *)
let test_atomic_tansfer_success =
  let initial_storage, owners, operators = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let owner2 = List_helper.nth_exn 1 owners in
  let owner3 = List_helper.nth_exn 2 owners in
  let op1    = List_helper.nth_exn 0 operators in
  let transfer_requests = ([
    ({from_=owner1; tx=([{to_=owner2;amount=2n;token_id=2n};] : FA2_multi_asset.atomic_trans list)});
  ] : FA2_multi_asset.transfer)
  in
  let () = Test.set_source op1 in 
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let _gas = Test.transfer_to_contract_exn contr (Transfer transfer_requests : FA2_multi_asset.parameter) 0tez in
  let () = assert_balances t_addr ((owner1, 2n, 8n), (owner2, 2n, 12n), (owner3, 3n, 10n)) in
  ()

(* 2. transfer failure token undefined *)
let test_transfer_token_undefined = 
  let initial_storage, owners, operators = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let owner2 = List_helper.nth_exn 1 owners in
  let owner3 = List_helper.nth_exn 2 owners in
  let op1    = List_helper.nth_exn 0 operators in
  let transfer_requests = ([
    ({from_=owner1; tx=([{to_=owner2;amount=2n;token_id=1n};{to_=owner3;amount=3n;token_id=2n}] : FA2_multi_asset.atomic_trans list)});
    ({from_=owner2; tx=([{to_=owner3;amount=2n;token_id=0n};{to_=owner1;amount=3n;token_id=2n}] : FA2_multi_asset.atomic_trans list)});
  ] : FA2_multi_asset.transfer)
  in
  let () = Test.set_source op1 in 
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let result = Test.transfer_to_contract contr (Transfer transfer_requests : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.undefined_token))
  | Fail _ -> failwith "invalid test failure"

(* 3. transfer failure incorrect operator *)
let test_atomic_transfer_failure_not_operator = 
  let initial_storage, owners, operators = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let owner2 = List_helper.nth_exn 1 owners in
  let op3    = List_helper.nth_exn 2 operators in
  let transfer_requests = ([
    ({from_=owner1; tx=([{to_=owner2;amount=2n;token_id=2n};] : FA2_multi_asset.atomic_trans list)});
  ] : FA2_multi_asset.transfer)
  in
  let () = Test.set_source op3 in 
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let result = Test.transfer_to_contract contr (Transfer transfer_requests : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.not_operator))
  | Fail _ -> failwith "invalid test failure"

(* 4. transfer failure insuffient balance *)
let test_atomic_transfer_failure_not_suffient_balance = 
  let initial_storage, owners, operators = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let owner2 = List_helper.nth_exn 1 owners in
  let op1    = List_helper.nth_exn 0 operators in
  let transfer_requests = ([
    ({from_=owner1; tx=([{to_=owner2;amount=12n;token_id=2n};] : FA2_multi_asset.atomic_trans list)});
  ] : FA2_multi_asset.transfer)
  in
  let () = Test.set_source op1 in 
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let result = Test.transfer_to_contract contr (Transfer transfer_requests : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.ins_balance))
  | Fail _ -> failwith "invalid test failure"

(* 5. transfer successful 0 amount & self transfer *)
let test_atomic_tansfer_success_zero_amount_and_self_transfer =
  let initial_storage, owners, operators = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let owner2 = List_helper.nth_exn 1 owners in
  let owner3 = List_helper.nth_exn 2 owners in
  let op1    = List_helper.nth_exn 0 operators in
  let transfer_requests = ([
    ({from_=owner1; tx=([{to_=owner2;amount=0n;token_id=1n};{to_=owner3;amount=0n;token_id=1n}] : FA2_multi_asset.atomic_trans list)});
    ({from_=owner2; tx=([{to_=owner2;amount=2n;token_id=2n};] : FA2_multi_asset.atomic_trans list)});
  ] : FA2_multi_asset.transfer)
  in
  let () = Test.set_source op1 in 
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let _gas = Test.transfer_to_contract_exn contr (Transfer transfer_requests : FA2_multi_asset.parameter) 0tez in
  let () = assert_balances t_addr ((owner1, 1n, 10n), (owner2, 2n, 10n), (owner3, 3n, 10n)) in
  ()

(* 6. transfer failure transitive operators *)
let test_transfer_failure_transitive_operators = 
  let initial_storage, owners, operators = get_initial_storage (10n, 10n, 10n) in
  let owner2 = List_helper.nth_exn 1 owners in
  let owner3 = List_helper.nth_exn 2 owners in
  let op3    = List_helper.nth_exn 2 operators in
  let transfer_requests = ([
    ({from_=owner3; tx=([{to_=owner2;amount=2n;token_id=2n};] : FA2_multi_asset.atomic_trans list)});
  ] : FA2_multi_asset.transfer)
  in
  let () = Test.set_source op3 in 
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let result = Test.transfer_to_contract contr (Transfer transfer_requests : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.not_operator))
  | Fail _ -> failwith "invalid test failure"

(* Balance of *)

(* 7. empty balance of + callback with empty response *)
let test_empty_transfer_and_balance_of = 
  let initial_storage, owners, _operators = get_initial_storage (10n, 10n, 10n) in
  let _owner1 = List_helper.nth_exn 0 owners in
  let (callback_addr,_,_) = Test.originate Callback.main ([] : nat list) 0tez in
  let callback_contract = Test.to_contract callback_addr in

  let balance_of_requests = ({
    requests = ([] : FA2_multi_asset.request list);
    callback = callback_contract;
  } : FA2_multi_asset.balance_of) in

  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let _gas = Test.transfer_to_contract_exn contr (Balance_of balance_of_requests: FA2_multi_asset.parameter) 0tez in

  let callback_storage = Test.get_storage callback_addr in
  assert (callback_storage = ([] : nat list))

(* 8. balance of failure token undefined *)
let test_balance_of_token_undefines = 
  let initial_storage, owners, _operators = get_initial_storage (10n, 5n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let owner2 = List_helper.nth_exn 1 owners in
  let (callback_addr,_,_) = Test.originate Callback.main ([] : nat list) 0tez in
  let callback_contract = Test.to_contract callback_addr in

  let balance_of_requests = ({
    requests = ([
      {owner=owner1;token_id=0n};
      {owner=owner2;token_id=2n};
      {owner=owner1;token_id=1n};
    ] : FA2_multi_asset.request list);
    callback = callback_contract;
  } : FA2_multi_asset.balance_of) in

  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let result = Test.transfer_to_contract contr (Balance_of balance_of_requests: FA2_multi_asset.parameter) 0tez in

  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.undefined_token))
  | Fail _ -> failwith "invalid test failure"

(* 9. duplicate balance_of requests *)
let test_balance_of_requests_with_duplicates = 
  let initial_storage, owners, _operators = get_initial_storage (10n, 5n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let owner2 = List_helper.nth_exn 1 owners in
  let (callback_addr,_,_) = Test.originate Callback.main ([] : nat list) 0tez in
  let callback_contract = Test.to_contract callback_addr in

  let balance_of_requests = ({
    requests = ([
      {owner=owner1;token_id=1n};
      {owner=owner2;token_id=2n};
      {owner=owner1;token_id=1n};
    ] : FA2_multi_asset.request list);
    callback = callback_contract;
  } : FA2_multi_asset.balance_of) in

  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let _gas = Test.transfer_to_contract_exn contr (Balance_of balance_of_requests: FA2_multi_asset.parameter) 0tez in

  let callback_storage = Test.get_storage callback_addr in
  assert (callback_storage = ([10n; 5n; 10n]))

(* 10. 0 balance if does not hold any tokens (not in ledger) *)
let test_balance_of_0_balance_if_address_does_not_hold_tokens = 
    let initial_storage, owners, operators = get_initial_storage (10n, 5n, 10n) in
    let owner1 = List_helper.nth_exn 0 owners in
    let owner2 = List_helper.nth_exn 1 owners in
    let op1    = List_helper.nth_exn 0 operators in
    let (callback_addr,_,_) = Test.originate Callback.main ([] : nat list) 0tez in
    let callback_contract = Test.to_contract callback_addr in

    let balance_of_requests = ({
      requests = ([
        {owner=owner1;token_id=1n};
        {owner=owner2;token_id=2n};
        {owner=op1;token_id=1n};
      ] : FA2_multi_asset.request list);
      callback = callback_contract;
    } : FA2_multi_asset.balance_of) in

    let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
    let contr = Test.to_contract t_addr in
    let _gas = Test.transfer_to_contract_exn contr (Balance_of balance_of_requests: FA2_multi_asset.parameter) 0tez in

    let callback_storage = Test.get_storage callback_addr in
    assert (callback_storage = ([10n; 5n; 0n]))


(* Update operators *)

(* 11. Remove operator & do transfer - failure *)
let test_update_operator_remove_operator_and_transfer = 
  let initial_storage, owners, operators = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let owner2 = List_helper.nth_exn 1 owners in
  let op1    = List_helper.nth_exn 0 operators in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in

  let () = Test.set_source owner1 in 
  let _gas = Test.transfer_to_contract_exn contr 
    (Update_operators ([
      (Remove_operator ({
        owner    = owner1;
        operator = op1;
        token_id = 2n;
      } : FA2_multi_asset.operator) : FA2_multi_asset.unit_update)
    ] : FA2_multi_asset.update_operators) : FA2_multi_asset.parameter) 0tez in

  let () = Test.set_source op1 in
  let transfer_requests = ([
    ({from_=owner1; tx=([{to_=owner2;amount=2n;token_id=2n};] : FA2_multi_asset.atomic_trans list)});
  ] : FA2_multi_asset.transfer)
  in
  let result = Test.transfer_to_contract contr (Transfer transfer_requests : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.not_operator))
  | Fail _ -> failwith "invalid test failure"

(* 12. Add operator & do transfer - success *)
let test_update_operator_add_operator_and_transfer = 
  let initial_storage, owners, operators = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let owner2 = List_helper.nth_exn 1 owners in
  let op3    = List_helper.nth_exn 2 operators in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in

  let () = Test.set_source owner1 in 
  let _gas = Test.transfer_to_contract_exn contr 
    (Update_operators ([
      (Add_operator ({
        owner    = owner1;
        operator = op3;
        token_id = 2n;
      } : FA2_multi_asset.operator) : FA2_multi_asset.unit_update);
    ] : FA2_multi_asset.update_operators) : FA2_multi_asset.parameter) 0tez in

  let () = Test.set_source op3 in
  let transfer_requests = ([
    ({from_=owner1; tx=([{to_=owner2;amount=2n;token_id=2n};] : FA2_multi_asset.atomic_trans list)});
  ] : FA2_multi_asset.transfer)
  in
  let _gas = Test.transfer_to_contract_exn contr (Transfer transfer_requests : FA2_multi_asset.parameter) 0tez in
  ()

(*
| Set_admin         p -> set_admin  p s
| Create_token      p -> create     p s
| Mint_token        p -> mint       p s
| Burn_token        p -> burn       p s
*)

(* Set_admin *)
let test_set_admin_check_sender_correct = 
  let initial_storage, owners, _ = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let owner2 = List_helper.nth_exn 1 owners in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let () = Test.set_source owner1 in
  let _gas = Test.transfer_to_contract_exn contr (Set_admin owner2 : FA2_multi_asset.parameter) 0tez in
  let () = Test.set_source owner2 in
  let _gas = Test.transfer_to_contract_exn contr (Set_admin owner1 : FA2_multi_asset.parameter) 0tez in
  ()

let test_set_admin_check_sender_wrong_sender =
  (* check the error message created when doing it wrong *)
  let initial_storage, owners, _ = get_initial_storage (10n, 10n, 10n) in
  let owner2 = List_helper.nth_exn 1 owners in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let () = Test.set_source owner2 in
  let result = Test.transfer_to_contract contr (Set_admin owner2 : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.requires_admin))
  | Fail _ -> failwith "invalid test failure"

let test_create_token_correct = 
  let initial_storage, owners, _ = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let () = Test.set_source owner1 in
  let _ = Test.transfer_to_contract_exn contr (Create_token {token_id = 10n; data = {token_id=10n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  ()

let test_create_token_wrong_sender =
  let initial_storage, owners, _ = get_initial_storage (10n, 10n, 10n) in
  let owner2 = List_helper.nth_exn 1 owners in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let () = Test.set_source owner2 in
  let result = Test.transfer_to_contract contr (Create_token {token_id = 10n; data = {token_id=10n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.requires_admin))
  | Fail _ -> failwith "invalid test failure"

let test_create_token_wrong_token_id = 
  let initial_storage, owners, _ = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let () = Test.set_source owner1 in
  let _ = Test.transfer_to_contract_exn contr (Create_token {token_id = 10n; data = {token_id=10n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  let result = Test.transfer_to_contract contr (Create_token {token_id = 10n; data = {token_id=10n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.token_exist))
  | Fail _ -> failwith "invalid test failure"

let test_mint_correct = 
  let initial_storage, owners, _ = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let () = Test.set_source owner1 in
  let _ = Test.transfer_to_contract_exn contr (Create_token {token_id = 10n; data = {token_id=10n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  let _ = Test.transfer_to_contract_exn contr (Create_token {token_id = 11n; data = {token_id=11n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  let _ = Test.transfer_to_contract_exn contr (Mint_token [{owner = owner1; token_id = 10n; amount_ = 10n}; {owner = owner1; token_id = 11n; amount_ = 20n}; ] : FA2_multi_asset.parameter) 0tez in
  ()

let test_mint_wrong_sender = 
  let initial_storage, owners, _ = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let owner2 = List_helper.nth_exn 1 owners in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let () = Test.set_source owner1 in
  let _ = Test.transfer_to_contract_exn contr (Create_token {token_id = 10n; data = {token_id=10n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  let _ = Test.transfer_to_contract_exn contr (Create_token {token_id = 11n; data = {token_id=11n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  let () = Test.set_source owner2 in
  let result = Test.transfer_to_contract contr (Mint_token [{owner = owner1; token_id = 10n; amount_ = 10n}; {owner = owner1; token_id = 11n; amount_ = 20n}; ] : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.requires_admin))
  | Fail _ -> failwith "invalid test failure"

let test_mint_wrong_token =
  let initial_storage, owners, _ = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let () = Test.set_source owner1 in
  let _ = Test.transfer_to_contract_exn contr (Create_token {token_id = 10n; data = {token_id=10n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  let result = Test.transfer_to_contract contr (Mint_token [{owner = owner1; token_id = 11n; amount_ = 10n}] : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.undefined_token))
  | Fail _ -> failwith "invalid test failure"

let test_burn_token_correct = 
  let initial_storage, owners, _ = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let () = Test.set_source owner1 in
  let _ = Test.transfer_to_contract_exn contr (Create_token {token_id = 10n; data = {token_id=10n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  let _ = Test.transfer_to_contract_exn contr (Mint_token [{owner = owner1; token_id = 10n; amount_ = 10n}] : FA2_multi_asset.parameter) 0tez in
  let _ = Test.transfer_to_contract_exn contr (Burn_token [{owner = owner1; token_id = 10n; amount_ = 10n}] : FA2_multi_asset.parameter) 0tez in
  ()

let test_burn_token_wrong_too_much = 
  let initial_storage, owners, _ = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let () = Test.set_source owner1 in
  let _ = Test.transfer_to_contract_exn contr (Create_token {token_id = 10n; data = {token_id=10n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  let _ = Test.transfer_to_contract_exn contr (Mint_token [{owner = owner1; token_id = 10n; amount_ = 10n}] : FA2_multi_asset.parameter) 0tez in
  let result = Test.transfer_to_contract contr (Burn_token [{owner = owner1; token_id = 10n; amount_ = 12n}] : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.ins_balance))
  | Fail _ -> failwith "invalid test failure"

let test_burn_token_wrong_sender = 
  let initial_storage, owners, _ = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let owner2 = List_helper.nth_exn 1 owners in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let () = Test.set_source owner1 in
  let _ = Test.transfer_to_contract_exn contr (Create_token {token_id = 10n; data = {token_id=10n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  let _ = Test.transfer_to_contract_exn contr (Mint_token [{owner = owner1; token_id = 10n; amount_ = 10n}] : FA2_multi_asset.parameter) 0tez in
  let () = Test.set_source owner2 in
  let result = Test.transfer_to_contract contr (Burn_token [{owner = owner1; token_id = 10n; amount_ = 10n}] : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.requires_admin))
  | Fail _ -> failwith "invalid test failure"

let test_burn_token_wrong_token = 
  let initial_storage, owners, _ = get_initial_storage (10n, 10n, 10n) in
  let owner1 = List_helper.nth_exn 0 owners in
  let (t_addr,_,_) = Test.originate FA2_multi_asset.main initial_storage 0tez in
  let contr = Test.to_contract t_addr in
  let () = Test.set_source owner1 in
  let _ = Test.transfer_to_contract_exn contr (Create_token {token_id = 10n; data = {token_id=10n;token_info=(Map.empty : (string, bytes) map)}} : FA2_multi_asset.parameter) 0tez in
  let _ = Test.transfer_to_contract_exn contr (Mint_token [{owner = owner1; token_id = 10n; amount_ = 10n}] : FA2_multi_asset.parameter) 0tez in
  let result = Test.transfer_to_contract contr (Burn_token [{owner = owner1; token_id = 55n; amount_ = 10n}] : FA2_multi_asset.parameter) 0tez in
  match result with
    Success _gas -> failwith "This test should fail"
  | Fail (Rejected (err, _))  -> 
    assert (Test.michelson_equal err (Test.eval FA2_multi_asset.Errors.ins_balance))
  | Fail _ -> failwith "invalid test failure"
