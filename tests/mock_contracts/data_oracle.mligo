#include "../../contracts/oracle_types.mligo"

[@view] let data (_foobar, _s: string * storage) : storage =
    // let () = failwith("Debug") in
    _s

let main(_param, s : param * storage) : (operation list * storage) =
  ([]: operation list), s
