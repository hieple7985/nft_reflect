type param = string

type data = {
    int: int;
    string: string;
    nat: nat
}

type country_data = {
  air_quality_index: int;
  happy_people: int;
  name: string
}

type storage = (string, (string, int) map) map

type response = storage
