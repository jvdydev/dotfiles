;;; judy-dev-misc.el --- Other dev stuff -*- lexical-binding: t; -*-
;;; Commentary:

;; Other development things that don't cleanly fit into the other places,
;; or that I don't use that often.

;;; Code:

;;; Packages
(add-to-list 'package-selected-packages 'go-mode)
(add-to-list 'package-selected-packages 'ocaml-ts-mode)
(add-to-list 'package-selected-packages 'ocamlformat)

;; 3D-Modelling using OpenSCAD
(add-to-list 'package-selected-packages 'scad-mode)

;;; Configuration
(my/post-install-run
 ;; golang
 (setq-default go-ts-mode-indent-offset 4)

 ;; OCaml
 (add-to-list 'load-path "/home/judy/.opam/default/share/emacs/site-lisp")
 (require 'ocp-indent)
 (with-eval-after-load 'eglot
   (add-to-list 'eglot-server-programs
                '(ocaml-ts-mode . ("ocamllsp" "--stdio")))))

;;; _
(provide 'judy-dev-misc)
;;; judy-dev-misc.el ends here
