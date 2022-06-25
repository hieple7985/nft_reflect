type set_oracle = {token_id: nat; oracle: TokenMutate.oracle }

let set_oracle ({token_id; oracle}, s : set_oracle * storage) : (operation list * storage) =
    let () = Storage.assert_admin s in

    let oracle_contract : (Oracle_types.param)contract = Tezos.get_contract_with_error oracle.address Errors.bad_oracle in

    let all_token_mutates : TokenMutate.t = Storage.get_token_mutate s in
    let all_token_mutates : TokenMutate.t = TokenMutate.set_oracle all_token_mutates token_id oracle in
    let s = Storage.set_token_mutate s all_token_mutates in

    ([]: operation list), s

type add_token_mutate_case = {token_id: nat; token_mutate_case: TokenMutate.case}

let add_token_mutate_case({token_id;token_mutate_case}, s : add_token_mutate_case * storage) : (operation list * storage) =
    let () = Storage.assert_admin s in
    
    let all_token_mutates : TokenMutate.t = Storage.get_token_mutate s in
    let all_token_mutates : TokenMutate.t = TokenMutate.add_token_mutate_case all_token_mutates token_id token_mutate_case in
    let s = Storage.set_token_mutate s all_token_mutates in
    
    ([]: operation list), s

type delete_token_mutate_cases = nat

let delete_token_mutate_cases(token_id, s : delete_token_mutate_cases * storage) : (operation list * storage) =
    let () = Storage.assert_admin s in
    
    let all_token_mutates : TokenMutate.t = Storage.get_token_mutate s in
    let all_token_mutates : TokenMutate.t = TokenMutate.delete_token_mutate_cases all_token_mutates token_id in
    let s = Storage.set_token_mutate s all_token_mutates in
    
    ([]: operation list), s
