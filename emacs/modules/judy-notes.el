;;; judy-notes.el --- Plaintext and note taking -*- lexical-binding: t; -*-
;;; Commentary:

;;

;;; Code:

;;; Packages
(add-to-list 'package-selected-packages 'hl-todo)
(add-to-list 'package-selected-packages 'org-appear)
(add-to-list 'package-selected-packages 'markdown-mode)

;;; Configuration
(my/post-install-run
 ;; Highlight "TODO", "NOTE", etc.
 (global-hl-todo-mode)

 ;; org-mode
 (require 'org)

 (setq initial-major-mode #'org-mode)

 (customize-set-variable 'org-hide-block-startup nil)
 (customize-set-variable 'org-fontify-quote-and-verse-blocks t)
 (customize-set-variable 'org-edit-src-content-indentation 0)
 (customize-set-variable 'org-src-fontify-natively t)
 (customize-set-variable 'org-src-tab-acts-natively t)
 (customize-set-variable 'org-src-preserve-indentation t)
 (customize-set-variable 'org-src-window-setup 'current-window)

 (customize-set-variable 'org-return-follows-link t)
 (customize-set-variable 'org-link-descriptive t)

 (add-hook 'org-mode-hook #'org-indent-mode)

 (customize-set-variable 'org-pretty-entities t)
 (customize-set-variable 'org-hide-emphasis-markers t)
 (add-hook 'org-mode-hook #'org-appear-mode)

 (require 'org-tempo)

 (require 'ox-md)
 (require 'ox-beamer)
 (require 'ox-texinfo)

 (customize-set-variable 'org-export-coding-system 'utf-8)

 (setq org-latex-listings 'minted
       org-latex-packages-alist '(("" "minted"))
       org-latex-pdf-process
       '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
         "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

 (require 'org-agenda)

 (unless-windows
  (cl-pushnew "~/notes/" org-agenda-files :test #'string-equal)))

;;; _
(provide 'judy-notes)
;;; judy-notes.el ends here
