#include "oracle_types.mligo"

type org_data = (string,
    (string,
        (string, response_value)map
    ) map
) map

type storage = (string, org_data) big_map

type return = operation list * storage

(*
let assert_admin (s:t) : unit =
    assert_with_error (Tezos.get_sender() = s.admin) Errors.requires_admin

let set_admin (s:t) (admin:address) = {s with admin = admin}
*)

[@view] let data (request, _s: view_data_param * storage) : response =
    let response_map : response = Map.empty in

    let find_data (response_map, (org_name, map1, map2) : response * (string * string * string)) : response =
        let key = org_name in

        let response_map = match Big_map.find_opt org_name _s with
          None -> ( Map.empty : response )
        | Some v1 -> 
            let key = key ^ "-" ^ map1 in

            let response_map2 = match Map.find_opt map1 v1 with
              None -> ( Map.empty : response )
            | Some v2 ->

                let key = key ^  "-" ^ map2 in

                let response_map3 = match Map.find_opt map2 v2 with
                  None -> ( Map.empty : response )
                | Some v3 -> Map.add key v3 response_map in

                response_map3 in
            response_map2 in
        response_map in

    List.fold_left find_data response_map request

type set_org_data = string * org_data

let set_org_data ((org_name, org_data), s : (string * org_data) * storage) : return =
    let s = match Big_map.find_opt org_name s with
      None -> Big_map.add org_name org_data s
    | Some v -> Big_map.update org_name (Some(org_data)) s in

    ([]: operation list), s

type parameter = [@layout:comb]
    | Set_org_data of set_org_data

type param = parameter

let main (p, s : parameter * storage) :  return = match p with
  Set_org_data  p -> set_org_data(p, s)
