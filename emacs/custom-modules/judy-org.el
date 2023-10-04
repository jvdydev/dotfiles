;;; judy-org.el --- org-mode and related module -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

;; Set initial buffer to org
(setq initial-major-mode #'org-mode)

;; Some pretty settings
(setq org-pretty-entities t
      org-hide-emphasis-markers t
      org-hide-block-startup nil
      org-fontify-quote-and-verse-blocks t
      org-edit-src-content-indentation 0
      org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-src-preserve-indentation t
      org-src-window-setup 'current-window)

;; fast src blocks etc.
(require 'org-tempo)

;; Load babel languages for evaluating blocks
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (C . t)
   (shell . t)
   (latex . t)
   (lisp . t)
   (org . t)
   (R . t)
   (scheme . t)))

;;; org-export
(require 'ox-md)
(require 'ox-beamer)
(require 'ox-texinfo)

(customize-set-variable 'org-export-coding-system 'utf-8)

;; set up LaTeX export to work with minted package
(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;;; _
(provide 'judy-org)
;;; judy-org.el ends here
