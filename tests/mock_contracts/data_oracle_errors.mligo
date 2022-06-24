#include "../../contracts/oracle_types.mligo"

let oracle_storage : storage = Map.literal [
    ("france", Map.literal[
     ("air_quality_index", 4);
     ("unhappy_people", 82);
    ])
]

[@view] let data (_foobar, _s: string * storage) : storage =
    let () = failwith("Oracle is supposed to fail") in
    _s

let main(_param, s : param * storage) : (operation list * storage) =
  ([]: operation list), s
