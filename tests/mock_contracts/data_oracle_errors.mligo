#include "../../contracts/oracle_types.mligo"

[@view] let data (_foobar, _s: string * storage) : storage =
    let () = failwith("Oracle is supposed to fail") in
    _s

let main(_param, s : param * storage) : (operation list * storage) =
  ([]: operation list), s
