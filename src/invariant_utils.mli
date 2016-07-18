(**************************************************************************)
(*                                                                        *)
(*  This file is part of Frama-C.                                         *)
(*                                                                        *)
(*  Copyright (C) 2007-2016                                               *)
(*    CEA (Commissariat à l'énergie atomique et aux énergies              *)
(*         alternatives)                                                  *)
(*                                                                        *)
(*  you can redistribute it and/or modify it under the terms of the GNU   *)
(*  Lesser General Public License as published by the Free Software       *)
(*  Foundation, version 3.                                                *)
(*                                                                        *)
(*  It is distributed in the hope that it will be useful,                 *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *)
(*  GNU Lesser General Public License for more details.                   *)
(*                                                                        *)
(*  See the GNU Lesser General Public License version 3                   *)
(*  for more details (enclosed in the file LICENCE).                      *)
(*                                                                        *)
(**************************************************************************)

type vec = Pilat_matrix.QMat.vec 
type mat = Lacaml_D.mat 


(** An invariant is an eigenspace, represented by its base with
    a vec list. 
    When an eigenspace is associated to an eigenvalue strictly 
    lower to one, the invariant is convergent 
    (<e,X> < k => <e,MX> <k).
    When it is higher to one, it is divergent
    (<e,X> > k => <e,MX> > k).
*)

type limit = 
  Convergent 
| Divergent 
| Altern
| One
| Zero

type invar = limit * vec list


val lim_to_string : limit -> string


(** Returns the rational eigenspaces union of the floating matrix 
    as a list of bases. *)
val invariant_computation : mat -> invar list

(** Intersects two union of vectorial spaces. *)
val intersection_invariants :  invar list -> invar list -> invar list

(** After the integration, there is no fraction left on the vector expression. *)
val integrate_vec : vec -> vec
