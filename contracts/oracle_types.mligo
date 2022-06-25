type param = string
type parameter = param

type response_value = {
    value: bytes;
    type_: string
}

type response = (string, (string, response_value) map) map
