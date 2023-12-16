;;; judy-completion.el --- Completion Module -*- lexical-binding: t; -*-

;;; Commentary:

;; Completion using the minad-stack.

;;; Code:

;;; vertico
(require 'vertico)
(require 'vertico-directory)

;; Better ergonomics
(customize-set-variable 'vertico-cycle t)
(define-key vertico-map (kbd "C-<backspace>") #'vertico-directory-delete-word)

(vertico-mode 1)

;;; Marginalia
(require 'marginalia)
(marginalia-mode 1)

;;; Consult
(keymap-global-set "C-s" 'consult-line)
(setq completion-in-region-function #'consult-completion-in-region)

(setq tab-always-indent 'complete)

;;; orderless
(require 'orderless)
(customize-set-variable 'completion-styles '(orderless flex basic))
(customize-set-variable 'completion-category-overrides
                        '((file (styles . (partial-completion)))))
(customize-set-variable 'completions-detailed t)

;;; Corfu
(require 'corfu)
(unless (display-graphic-p)
  (require 'corfu-terminal)
  (corfu-terminal-mode 1))

;; Extensions
(require 'corfu-popupinfo)
(require 'corfu-echo)

(customize-set-variable 'corfu-cycle t)
(customize-set-variable 'corfu-auto t)
(customize-set-variable 'corfu-auto-prefix 2)

(customize-set-variable 'corfu-quit-no-match t)
(customize-set-variable 'corfu-preview-current nil)

;; (customize-set-variable 'corfu-popupinfo-delay t)
(customize-set-variable 'corfu-popupinfo-max-height 15)

;; Load extensions
(add-hook 'corfu-mode-hook #'corfu-popupinfo-mode)
(add-hook 'corfu-mode-hook #'corfu-echo-mode)

(global-corfu-mode 1)

(customize-set-variable 'tab-always-indent 'complete)

;;; Cape
(require 'cape)

;; Complete file paths
(add-to-list 'completion-at-point-functions #'cape-file)
(add-to-list 'completion-at-point-functions #'cape-dabbrev)

;; Interop fix with corfu
(advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)
(advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify)

;;; _
(provide 'judy-completion)
;;; judy-completion.el ends here
