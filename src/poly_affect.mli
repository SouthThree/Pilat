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
(*  Foundation, version 2.1.                                              *)
(*                                                                        *)
(*  It is distributed in the hope that it will be useful,                 *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *)
(*  GNU Lesser General Public License for more details.                   *)
(*                                                                        *)
(*  See the GNU Lesser General Public License version 2.1                 *)
(*  for more details (enclosed in the file LICENCE).                      *)
(*                                                                        *)
(**************************************************************************)

open Cil_datatype
open Pilat_math

exception Incomplete_base
exception Not_solvable


module type S = sig 

  (** 1. Utils *)


  type mat (** Matrix in which the affectation will be translated *)

  module P : 
    (sig 
      include Polynomial       
  (** Takes a monomial and its affectation, returns a matrix and its base. 
      If a base is provided it will complete it and use it for the matrix, else it 
      will create a new base from the affectation.
      Raises Incomplete_base if unconsidered variables are necessary for the matrix.
  *)
      val to_mat : ?base:int Monom.Map.t -> Monom.t -> t -> int Monom.Map.t * mat
     end)

  type coef = P.c (** Coefficient of the polynomial *)
  type var = P.v (** Variables used by the polynomial *)

  type monomial = P.Monom.t
  type m_set = P.Monom.Set.t
  type p = P.t

  type t = 
    Affect of var * p
  | Loop of body list 

  and body = t list

  (** A monomial affectation is equivalent to considering a monomial is a variable modified
    by the affectation. *)
  type monom_affect = monomial * p

  (** 2. Ast to matrix translators *)  

  val exp_to_poly : Cil_types.exp -> P.t

  val block_to_poly_lists : P.Var.Set.t-> Cil_types.block -> body list
(** Returns a list of list of polynomial affectations. Each list correspond to a the 
    succession of affectations for each possible path in the loop, while omitting 
    variable absent of the set in argument
    Raises Not_solvable if a statement of the loop is not solvable. *)

  val add_monomial_modifications : 
    body -> monom_affect list * P.Monom.Set.t
(** Returns the list of monomial affectations needed to linearize the loop, and the
    set of all monomials used. *)

end
  
module Make: 
  functor (P : Polynomial with type v = Varinfo.t)(M : Matrix with type elt = P.c) -> 
    S 
  
