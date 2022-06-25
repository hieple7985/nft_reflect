type param = string
type parameter = param

type response_value = {
    value: bytes;
    type_: string
}

type response = (string, (string, response_value) map) map

type view_data_param = (string * string * string) list
type view_data_params = view_data_param

// You must create a view named data that takes in view_data_param type as its parameter, and returns a type response
// Do not overwrite the types in this file
