module BIG_MAP =
struct
    let _returns_key (type k v) (key, big_map : k * ((k, v) big_map)) : v = // Will throw if key doesn't exist
      match Big_map.find_opt key big_map with
        Some v -> v
      | None -> failwith ("no key in big_map")

    let _is_empty (type k v) (big_map : (k, v)big_map) : bool =
        false

    let _has_key (type k v) (key, big_map : k * ((k, v) big_map)) : bool =
      match Big_map.find_opt key big_map with
        Some _ -> true
      | None -> false

    let to_be_empty (type k v) (big_map : (k, v)big_map) : nat = 
        if _is_empty big_map then 0n
        else let _ = print_fail("Expected big_map to be empty:", big_map) in 1n

    let to_not_be_empty (type k v) (big_map : (k, v)big_map) : nat = 
        if _is_empty big_map then
            let _ = print_fail("Expected big_map to not be empty:", big_map) in 1n
        else 0n

    let to_not_be_none (type k v) (big_map : (k,v)big_map option) : nat =
      match big_map with 
        Some _ -> 0n
      | None -> 1n

    let to_have_key (type k v) (key, big_map : k * ((k, v) big_map)) : nat =
      if _has_key(key, big_map)=true then 0n
      else let _ = print_fail("Expected to have key ", key, " in ", big_map) in 1n

    let to_have_key_of_value (type k v) (key, expected_value, big_map : k * v * ((k, v) big_map)) : nat =
      if _has_key(key, big_map)=true then
        let value = _returns_key(key, big_map) in
       // let _ = Test.log("***********RETURNNING KEY**********************", _returns_key(key, big_map)) in
        if Test.compile_value value = Test.compile_value expected_value then 0n
        else
          let _ = print_fail("Expected ", key, " to be ", expected_value,"but got", value) in
          1n
      else
        let _ = print_fail("Expected to find", key, "in", big_map) in
        1n

    let to_have_key_with_value (type k v) (key, expected_value, big_map : k * v * ((k, v) big_map)) : nat =
        to_have_key_of_value(key, expected_value, big_map)

    let to_not_have_key (type k v) (key, big_map : k * ((k, v) big_map)) : nat =
      if _has_key(key, big_map)=true then 1n
      else 0n
end
