#include "TZIP-12/with_mint_and_burn/FA2_multi_asset_updated.mligo"

type metadata_mutate = {
  name: string;
  display_uri: string;
}

type token_id = nat

type metadata_mutate_map = (token_id, metadata_mutate) map

[@view] let token_metadata (token_id, _s : token_id * storage) : TokenMetadata.data option =
  // let data : TokenMetadata.data ={token_id=token_id; token_info =(Map.empty : (string, bytes) map)} in
  Big_map.find_opt token_id _s.token_metadata
  // data

(*
type parameter = [@layout:comb]
  | Transfer of transfer
  | Balance_of of balance_of
  | Update_operators of update_operators
  // | Token_metadata of token_id

let main ((p,s):(parameter * storage)) = match p with
   Transfer         p -> transfer   p s
|  Balance_of       p -> balance_of p s
|  Update_operators p -> update_ops p s
// |  Token_metadata   p -> token_metadata (p, s)
*)
