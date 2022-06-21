#import "../../contracts/nft.mligo" "FA2"

type param = address

type country_data = {
  air_quality_index: int;
  happy_people: int;
  name: string
}

type storage = (string, country_data) map

let oracle_storage : storage = Map.literal [
  ("france", {air_quality_index=4; happy_people=72; name="France"})
]

let main((), s : param * storage option) : (operation list * storage) =
  ([]: operation list), oracle_storage
