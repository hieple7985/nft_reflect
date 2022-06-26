# Real World Art NFTs on Tezos

## Metadata
Apparently, on-chain views and off-chain views are very different. This project utilizes on-chain views to update the metadata of tokens.
The contract admin can set an oracle with a view entrypoint "data", and the cases it will test the response from the oracle. You can only set one oracle per token.

The metadata for these NFTs can be mutated. To make your NFTs have names, descriptions, display images, etc that change, you'll need
- [An oracle](#oracle):
- For token images, links to the images you're planning to use.

### How To
When you mint or create your token, make sure you add your token metadata fields. If your oracle ever fails for any reason, the metadata you've set on token creation will be returned. It can also be used as the default case.

#### SetOracle
After minting, you are ready to start defining on what conditions your token metadata will change. You'll decide which fields to change.
First thing you need to do is set an oracle for the token. The oracle should have a `data` view entrypoint that returns an `Oracle.response` type. (See contracts/oracle_types.mligo).

To set an oracle, call the `SetOracle` entrypoint with the token_id and the oracle details.

```
  SetOracle {token_id=token_id; oracle={address=("<oracle-address>": address); params=[("organisation_name", "org_data_level1", "org_data_level2")]}}
```

#### AddMutateCase - Add metadata mutation cases
You can only call the `AddMutateCase` for a token if an oracle has already been set for that token's mutation mapping. 
`AddMutateCase (field, (condition, value) map)`. `condition` is a string, and `value` is a map. You can only call addMetadataMutation if you have previously added an oracle with `addOracle`

#### Example
Say you had a token you wanted to change it's name, displayUri, description... depending on the weather
  You would set the oracle first, 
  ```
  SetOracle oracle={address=("<oracle-address>": address); params=[("open_weatherm", "cities", "france")]};
  ```

```
AddMutateCase {
  token_id=token_id;
  token_mutate_case = [
      {
          condition={ // If the weather_code is is greater than or equal to 200
              top_level_param_name= "open_weatherm-cities-france";
              param_name="weather_code";
              operator = ">=";
              value=Bytes.pack 200;
          };
          fields=[ // Set the following fields to the values in value
              { name="name"; value=Bytes.pack "Boom! Crackle" };
              { name="displayUri"; value=Bytes.pack "https://images.nightcafe.studio/jobs/XMoRdDsAq6cnC0skGZ2l/XMoRdDsAq6cnC0skGZ2l.jpg?tr=w-640,c-at_max"};
              { name="description"; value=Bytes.pack "Make sure to stay indoors today!" };
          ]
      };

      {
          condition={
              top_level_param_name="open_weatherm-cities-france";
              param_name="weather_code";
              operator = ">=";
              value=Bytes.pack 500;
          };
          fields=[
              { name="name"; value=Bytes.pack "Drop drop..." };
              { name="displayUri"; value=Bytes.pack "https://images.nightcafe.studio/jobs/fIOxMyt260Rt35Fzkgn5/fIOxMyt260Rt35Fzkgn5.jpg?tr=w-1600,c-at_max"};
              { name="description"; value=Bytes.pack "Maybe carry an umbrella..." };
          ]
      };

      {
          condition={
              top_level_param_name="open_weatherm-cities-france";
              param_name="weather_code";
              operator = ">=";
              value=Bytes.pack 600;
          };
          fields=[
              { name="name"; value=Bytes.pack "Snow" };
              { name="displayUri"; value=Bytes.pack "https://images.nightcafe.studio/jobs/IfouuMWlC3mgDW9zxJ2v/IfouuMWlC3mgDW9zxJ2v--150--AJ2EC.jpg?tr=w-640,c-at_max"};
              { name="description"; value=Bytes.pack "Do you wanna build a snowman?" };
          ]
      };

      {
          condition={
              top_level_param_name="open_weatherm-cities-france";
              param_name="weather_code";
              operator = ">=";
              value=Bytes.pack 700;
          };
          fields=[
              { name="name"; value=Bytes.pack "Something in the air" };
              { name="displayUri"; value=Bytes.pack "https://images.nightcafe.studio/jobs/VOznDO6EJgl7K0rNBQVZ/VOznDO6EJgl7K0rNBQVZ.jpg?tr=w-1600,c-at_max"};
              { name="description"; value=Bytes.pack "There's something in the air today... You might want to wear some spectacles today, or hunker down and prep for a possible tornado..." };
          ]
      };
  ]
}
```

Note: the token metadata mutate can only deal with simple cases like `=`, `<>` (not equal to), `<`, `<=`, `>`, `>=`.

View the oracle [KT1UUsRrhdwoMg8V86bJmpNXgDCYo9SJ31YJ](https://better-call.dev/ithacanet/KT1UUsRrhdwoMg8V86bJmpNXgDCYo9SJ31YJ/storage/big_map/149053/keys) and the FA2 example contract at [KT19Z6AQpeG1Dy2sw8CsKp4iRPy55qfVgc56](https://better-call.dev/ithacanet/KT19Z6AQpeG1Dy2sw8CsKp4iRPy55qfVgc56/views)
