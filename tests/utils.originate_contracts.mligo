#import "utils.mligo" "UTILS"
#import "mock_contracts/data_oracle.mligo" "MockOracle"
#import "../contracts/nft.mligo" "FA2"

let get_initial_storage = UTILS.get_initial_storage

let mock_oracle (init_storage: MockOracle.storage option) : address * (MockOracle.param, MockOracle.storage)typed_address * (MockOracle.param)contract =
    let oracle_storage : MockOracle.storage = match init_storage with
      Some v -> v
    | None -> Map.literal [
        ("japan", Map.literal[
         ("air_quality_index", {value=Bytes.pack(4); type_="int"});
         ("happy_people", {value=Bytes.pack(72); type_="int"});
        ])
    ] in

    let compiler = fun(x: MockOracle.storage) -> x in
    let (mockOracle_addr, _,_) = Test.originate_from_file "tests/mock_contracts/data_oracle.mligo" "main" ["data"] (Test.run compiler oracle_storage) 0tez in
    let (mockOracle_taddr, _,_) = Test.originate MockOracle.main oracle_storage 0tez in
    let mockOracle = Test.to_contract mockOracle_taddr in

    (mockOracle_addr, mockOracle_taddr, mockOracle)

let mockOracle = mock_oracle

let nft (init_storage: FA2.storage option) : address * (FA2.parameter, FA2.storage)typed_address * (FA2.parameter)contract =
    let nft_storage : FA2.storage = match init_storage with
      None -> let storage = get_initial_storage(10n, 10n, 10n) in storage.0
    | Some v -> v in

    let ii2 = fun(x : FA2.storage) -> x in
    let ii2 = Test.run ii2 nft_storage  in

    let (nft_addr, _,_) = Test.originate_from_file "contracts/nft.mligo" "main" ["token_metadata"] ii2 0tez in
    let nft_taddr : (FA2.parameter, FA2.storage)typed_address = Test.cast_address(nft_addr) in
    let nft = Test.to_contract nft_taddr in

    (nft_addr, nft_taddr, nft)

