# Real World Art NFTs on Tezos

## Metadata
The metadata for these NFTs can be mutated. To make your NFTs have names, descriptions, display images, etc that change, you'll need
- An oracle:
- For token images, links to the images you're planning to use.

### How To
When you mint your token, make sure you add your token metadata fields. If your oracle ever fails, the metadata you've entered will be used.
- After minting, call `addMetadataMutation(field, (condition, value) map)`. `condition` is a string, and `value` is a map.
For example, let's say you're fetching data from an oracle that reports on health stats for a city. It's return looks like this
```
{
        health_index: 72,
        population: 11263
        ...
}
```

Say your field is the token displayUri. You want to display a different images for different contions:
        - image1 when the oracle returns { health_index < 50 }
                - `addMetadataMutation("displayUri", "oracle1.health_index<50", "https://image1.jpg")`
        - image2 when the oracle returns { health_index = 50 }
                - `addMetadataMutation("displayUri", "oracle1.health_index=50", "https://image2.jpg")`
        - image3 when the oracle returns { health_index > 50 }
                - `addMetadataMutation("displayUri", "oracle1.health_index>50", "https://image3.jpg")`

