type token_id = nat

[@view] let token_metadata (token_id, _s : token_id * storage) : TokenMetadata.data =
    let token_data = match Big_map.find_opt token_id _s.token_metadata with
        Some v -> v
        | None -> failwith("token not found. ID", token_id) in

    let token_info = token_data.token_info in

    let mutate_info = Big_map.find_opt token_id _s.token_metadata_mutate in

    let updated_token_info = match mutate_info with
          None -> token_info
        | Some mutate -> 
            let oracle_addr : address = mutate.oracle.address in
            let oracle : (Oracle_types.param)contract = Tezos.get_contract_with_error oracle_addr "Oracle not found" in

            let oracle_response : Oracle_types.response option = Tezos.call_view "data" mutate.oracle.params oracle_addr in
            // let oracle_response : Oracle_types.response option = Tezos.call_view "data" "foo_bar" oracle_addr in

            let updated_token_info = match oracle_response with
              None -> token_info
              // None -> failwith("empty response from oracle")
            | Some k ->
                let update_fields = fun(new_token_info, field : TokenMetadata.token_info * MetadataMutate.field) ->
                    let new_token_info: TokenMetadata.token_info = match Map.find_opt field.name new_token_info with
                        // None -> failwith(field.name ^ "not found in map")
                        // | Some _ -> failwith(field.name ^ "found in map")
                        None -> Map.add field.name field.value new_token_info
                        | Some _ -> Map.update field.name (Some(field.value)) new_token_info

                    in new_token_info
                in

                // Loop through conditions. If condition is true, loop through and update fields
                // Returns token_data
                let loop_cases = fun(u_token_info, case : TokenMetadata.token_info * MetadataMutate.case) ->
                    let condition = case.condition in
                    let u_token_info =
                        (*
                        if ParseCondition.parseResponse(condition.top_level_param_name, condition.param_name, condition.operator, condition.value, k)
                        then
                        *)
                            List.fold update_fields case.fields u_token_info
                        // else u_token_info
                     in
                     u_token_info
                in

                let new_token_info = token_data.token_info in
                List.fold loop_cases mutate.cases new_token_info in
            updated_token_info in

    let data = {token_data with token_info=updated_token_info} in
    data

// DEBUG FN
(*
[@view] let token_metadata (token_id, _s : token_id * storage) : TokenMetadata.data =
  match Big_map.find_opt token_id _s.token_metadata with
      // Some _ -> token_data
      // Some _ -> failwith("not found")
      Some v -> v
    | None -> failwith("token not found. ID", token_id)
  // failwith("oajifa")

  let () = failwith(token_id) in

  Some(data)
*)

