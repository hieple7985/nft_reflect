let _returns_key (type k v) (key, map : k * ((k, v) map)) : v = // Will throw if key doesn't exist
  match Map.find_opt key map with
    Some v -> v
  | None -> failwith ("no key in map")

let _has_key (type k v) (key, map : k * ((k, v) map)) : bool =
  match Map.find_opt key map with
    Some _ -> true
  | None -> false

let to_have_key (type k v) (key, map : k * ((k, v) map)) : nat =
  if _has_key(key, map)=true then 0n
  else 1n

let to_have_key_of_value (type k v) (key, map, value : k * ((k, v) map) * v) : nat =
  if _has_key(key, map)=true then
    let value_from_map = _returns_key(key, map) in
   // let _ = Test.log("***********RETURNNING KEY**********************", _returns_key(key, map)) in
    if Test.compile_value value_from_map = Test.compile_value value then 0n
    else 1n

    // if Test.compile_value _returns_key (key, map) = Test.compile_value value
      // then 0n
    // else 1n
  else 1n

let to_not_have_key (type k v) (key, map : k * ((k, v) map)) : nat =
  if _has_key(key, map)=true then 1n
  else 0n
