#import "oracle_types.mligo" "Oracle_types"
#import "utils.parseCondition.mligo" "ParseCondition"
#include "FA2_multi_asset_updated.mligo"
#include "View_TokenMetadata.mligo"
#include "mutate_metadata.mligo"

type parameter = [@layout:comb]
   | Transfer of transfer
   | Balance_of of balance_of
   | Update_operators of update_operators
   | Set_admin of address
   | Create_token of create_token
   (* alternative where create also mint
   | Create_token of create_token * address * mint *)
   | Mint_token of mint_or_burn list
   | Burn_token of mint_or_burn list
   (* Token mutation actions *)
   | SetOracle of set_oracle
   | AddMutateCase of add_token_mutate_case
   | DeleteMutateCases of delete_token_mutate_cases

let main ((p,s):(parameter * storage)) = match p with
   Transfer         p -> transfer   p s
|  Balance_of       p -> balance_of p s
|  Update_operators p -> update_ops p s

(* extended admin operations *)
| Set_admin         p -> set_admin  p s
| Create_token      p -> create     p s
| Mint_token        p -> mint       p s
| Burn_token        p -> burn       p s

(* Metadata mutate operations *)
| SetOracle         p -> set_oracle(p, s)
| AddMutateCase     p -> add_token_mutate_case(p, s)
| DeleteMutateCases p -> delete_token_mutate_cases(p, s)
