module MAP =
struct
    let _returns_key (type k v) (key, map : k * ((k, v) map)) : v = // Will throw if key doesn't exist
      match Map.find_opt key map with
        Some v -> v
      | None -> failwith ("no key in map")

    let _is_empty (type k v) (map : (k, v)map) : bool =
        Map.size map = 0n

    let _has_key (type k v) (key, map : k * ((k, v) map)) : bool =
      match Map.find_opt key map with
        Some _ -> true
      | None -> false

    let to_be_empty (type k v) (map : (k, v)map) : nat = 
        if _is_empty map then 0n
        else let _ = print_fail("Expected map to be empty:", map) in 1n

    let to_not_be_empty (type k v) (map : (k, v)map) : nat = 
        if _is_empty map then
            let _ = print_fail("Expected map to not be empty:", map) in 1n
        else 0n

    let to_not_be_none (type k v) (map : (k,v)map option) : nat =
      match map with 
        Some _ -> 0n
      | None -> 1n

    let to_have_key (type k v) (key, map : k * ((k, v) map)) : nat =
      if _has_key(key, map)=true then 0n
      else let _ = print_fail("Expected to have key ", key, " in ", map) in 1n

    let to_have_key_of_value (type k v) (key, expected_value, map : k * v * ((k, v) map)) : nat =
      if _has_key(key, map)=true then
        let value = _returns_key(key, map) in
       // let _ = Test.log("***********RETURNNING KEY**********************", _returns_key(key, map)) in
        if Test.compile_value value = Test.compile_value expected_value then 0n
        else
          let _ = print_fail("Expected ", key, " to be ", expected_value,"but got", value) in
          1n
      else
        let _ = print_fail("Expected to find", key, "in", map) in
        1n

    let to_have_key_with_value (type k v) (key, expected_value, map : k * v * ((k, v) map)) : nat =
        to_have_key_of_value(key, expected_value, map)

    let to_not_have_key (type k v) (key, map : k * ((k, v) map)) : nat =
      if _has_key(key, map)=true then 1n
      else 0n
end
