type t = string
[@@deriving_inline yojson]
let _ = fun (_ : t) -> ()
let t_of_yojson = (string_of_yojson : Ppx_yojson_conv_lib.Yojson.Safe.t -> t)
let _ = t_of_yojson
let t_of_yojson' =
  (let _tp_loc = "src/lsp/uri.ml.t" in
   fun yojson ->
     Ppx_yojson_conv_lib.Yojson_conv.Result.pack
       (fun yojson -> t_of_yojson yojson) yojson : Ppx_yojson_conv_lib.Yojson.Safe.t
                                                     ->
                                                     t
                                                       Ppx_yojson_conv_lib.Yojson_conv.Result.t)
let _ = t_of_yojson'
let yojson_of_t = (yojson_of_string : t -> Ppx_yojson_conv_lib.Yojson.Safe.t)
let _ = yojson_of_t
[@@@end]

let to_string uri = uri

let to_path (uri : t) =
  let proto =
    match Sys.win32 with
    | true -> "file:///"
    | false -> "file://"
  in
  let path =
    match Std.String.chop_prefix ~prefix:proto uri with
    | Some path -> path
    | None -> uri in
  path
  |> Std.String.replace_all ~pattern:"\\" ~with_:"/"
  |> Std.String.replace_all ~pattern:"%3A" ~with_:":"
  |> Std.String.replace_all ~pattern:"%5C" ~with_:"/"

let of_path (path : string) =
  let proto = match Sys.win32 with
    | true -> "file:///"
    | false -> "file://"
  in
  let path =
    path
    |> Std.String.replace_all ~pattern:"\\" ~with_:"/"
    |> Std.String.replace_all ~pattern:":" ~with_:"%3A"
  in
  proto ^ path

let pp fmt uri = Format.fprintf fmt "%s" uri
