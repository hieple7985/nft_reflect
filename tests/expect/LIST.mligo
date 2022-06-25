#include "./utils.mligo"

module LIST =
    struct
        let _to_be_empty (type v) (list : v list) : bool =
            List.length list = 0n

        let to_be_empty (type v) (list : v list) : nat =
            if _to_be_empty list then 0n
            else let _ = UTILS.print_fail ("Expected", list, "to be empty") in
                1n

        let to_not_be_empty (type v) (list : v list) : nat =
            if _to_be_empty list then
                let _ = UTILS.print_fail ("Expected", list, "to not be empty") in
                    1n
            else 0n

        let to_not_be_empty (type v) (list : v list) : nat =
             to_not_be_empty list
    end

