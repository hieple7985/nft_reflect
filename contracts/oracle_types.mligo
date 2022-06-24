type param = string
type parameter = param

type response_value = {
    value: bytes;
    type_: string
}

type storage = (string, (string, response_value) map) map

type response = storage
