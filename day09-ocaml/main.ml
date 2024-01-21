open Printf
open String

let rec take_last l = match l with
    | [] -> 0
    | [e] -> e
    | _::tl -> take_last tl


let diff l =
    let rec remove_last l = match l with 
       | [] -> [] 
       | [_] -> [] 
       | hd::tl -> hd::(remove_last tl) in
    List.map (fun (x, y) -> y - x) (List.combine (remove_last l) (List.tl l))

let finished l = List.for_all (fun x -> x == 0) l

let rec sol1 l =
    if (finished l) then take_last l else take_last l + (sol1 (diff l))

let rec sol2 l =
    if (finished l) then 0 else List.hd l - sol2 (diff l)

let () =
    let filename = "input.txt" in
    let rec read_lines f =
        try
            let line = input_line f in
            let values = split_on_char ' ' line in
            (List.map int_of_string values) :: read_lines f
        with 
            | End_of_file -> close_in f;
            [] in
    let results1 = List.map sol1 (read_lines (open_in filename)) in
    let results2 = List.map sol2 (read_lines (open_in filename)) in
    let res1 = List.fold_left (+) 0 results1 in
    let res2 = List.fold_left (+) 0 results2 in
    printf "result 1: %d\nresult 2: %d" res1 res2

