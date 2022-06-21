#import "../../contracts/nft.mligo" "FA2"

type storage = FA2.TokenMetadata.data
type param = address

let main(addr, s : param * storage option) : (operation list * storage option) =
  let token_id = match s with
    Some v -> v.token_id
  | None -> (failwith("No token") : 
  in
  let metadata : storage option = Tezos.call_view "token_metadata" token_id addr in
  ([]: operation list), metadata
