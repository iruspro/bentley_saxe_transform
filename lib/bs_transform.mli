(** Bentley-Saxe transformation: turns a static decomposable search
    structure into a dynamic one supporting insertions. *)

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

module Make (S : Static) : sig
  type t
  type elt = S.elt
  type query = S.query
  type answer = S.answer

  val empty : t
  val insert : t -> elt -> t
  val search : t -> query -> answer option
end
