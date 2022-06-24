type storage = (string, bool) map

let counter : storage = Map.literal[
  ("has_been_called", false)
]

let main((), _ : unit * storage option) : (operation list * storage option) =
([]: operation list), Some(counter)
