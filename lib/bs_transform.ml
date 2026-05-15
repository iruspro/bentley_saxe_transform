module type Static = sig
  type elt
  type t
  type query
  type answer

  val of_seq : elt Seq.t -> t
  val to_iter : t -> elt Seq.t
  val search : t -> query -> answer
  val combine : answer -> answer -> answer
end

module Make (S : Static) = struct
  type t = S.t option list
  type elt = S.elt
  type query = S.query
  type answer = S.answer

  let empty : t = []

  let rec insert_at levels carry =
    match levels with
    | [] -> [ Some (S.of_seq carry) ]
    | None :: rest -> Some (S.of_seq carry) :: rest
    | Some existing :: rest ->
        let merged = Seq.append (S.to_iter existing) carry in
        None :: insert_at rest merged

  let insert t x = insert_at t (Seq.return x)

  let search t q =
    List.fold_left
      (fun acc level ->
        match (acc, level) with
        | _, None -> acc
        | None, Some s -> Some (S.search s q)
        | Some a, Some s -> Some (S.combine a (S.search s q)))
      None t
end
