#include "../../contracts/oracle_types.mligo"

type storage = response

[@view] let data (_foobar, _s: view_data_param * storage) : storage =
    // let () = failwith("Debug") in
    _s

let main(_param, s : param * storage) : (operation list * storage) =
  ([]: operation list), s
