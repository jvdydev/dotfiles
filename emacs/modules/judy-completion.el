;;; judy-completion.el --- Completion Module -*- lexical-binding: t; -*-

;;; Commentary:

;; Completion using the minad-stack.

;;; Code:

;;; Packages
(add-to-list 'package-selected-packages 'consult)
(add-to-list 'package-selected-packages 'vertico)
(add-to-list 'package-selected-packages 'marginalia)
(add-to-list 'package-selected-packages 'orderless)

;;; Package Configuration
(my/post-install-run
 ;; vertico
 (require 'vertico)
 (require 'vertico-directory)

 (customize-set-variable 'vertico-cycle t)
 (define-key vertico-map (kbd "C-<backspace>") #'vertico-directory-delete-word)
 (vertico-mode 1)

 ;; Marginalia
 (require 'marginalia)
 (marginalia-mode 1)

 ;; Consult
 (keymap-global-set "C-s" 'consult-line)
 (setq completion-in-region-function #'consult-completion-in-region)

 ;; orderless
 (require 'orderless)
 (customize-set-variable 'completion-styles '(orderless flex basic))
 (customize-set-variable 'completion-category-overrides
                         '((file (styles . (partial-completion)))))
 (customize-set-variable 'completions-detailed t)
 (customize-set-variable 'tab-always-indent 'complete))

;;; _
(provide 'judy-completion)
;;; judy-completion.el ends here
