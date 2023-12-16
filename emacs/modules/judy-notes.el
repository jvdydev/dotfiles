;;; judy-notes.el --- Plaintext and note taking -*- lexical-binding: t; -*-
;;; Commentary:

;;

;;; Code:

;;; org-mode
(require 'org)

;; Set initial buffer to org
(setq initial-major-mode #'org-mode)

;; Layouting (e.g. src-blocks)
(customize-set-variable 'org-hide-block-startup nil)
(customize-set-variable 'org-fontify-quote-and-verse-blocks t)
(customize-set-variable 'org-edit-src-content-indentation 0)
(customize-set-variable 'org-src-fontify-natively t)
(customize-set-variable 'org-src-tab-acts-natively t)
(customize-set-variable 'org-src-preserve-indentation t)
(customize-set-variable 'org-src-window-setup 'current-window)

;; Links
(customize-set-variable 'org-return-follows-link t)
(customize-set-variable 'org-link-descriptive t)

;; visual indenting
(add-hook 'org-mode-hook #'org-indent-mode)

;; prettify
(customize-set-variable 'org-pretty-entities t)
(customize-set-variable 'org-hide-emphasis-markers t)
(add-hook 'org-mode-hook #'org-appear-mode)

;; Creating blocks fast
(require 'org-tempo)

;;;; org-export
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
(provide 'judy-notes)
;;; judy-notes.el ends here
