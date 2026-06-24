;; SPDX-License-Identifier: MPL-2.0
;; Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
;;
;; Guix development environment for TradeUnionist.jl.
;; Replaces the removed flake.nix per the estate Guix-only policy.
;; Usage: guix shell -D -f guix.scm

(use-modules (guix packages)
             (guix build-system gnu)
             (gnu packages julia))

(package
  (name "tradeunionist-jl")
  (version "0.1.0")
  (source #f)
  (build-system gnu-build-system)
  (native-inputs
   (list julia))
  (synopsis "TradeUnionist.jl")
  (description
   "TradeUnionist.jl — part of the hyperpolymath ecosystem.")
  (home-page "https://github.com/hyperpolymath/TradeUnionist.jl")
  (license ((@@ (guix licenses) license) "MPL-2.0"
             "https://github.com/hyperpolymath/palimpsest-license")))
