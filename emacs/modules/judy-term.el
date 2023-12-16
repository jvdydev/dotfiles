;;; judy-term.el --- Terminal and Shell configuration -*- lexical-binding: t; -*-
;;; Commentary:

;; Minimal terminal configs (vterm, term, eshell).

;;; Code:

;;; term/vterm
(unless-windows
  (setq explicit-shell-file-name "bash")
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  (setq vterm-max-scrollback 10000))

;; eshell
(require 'eshell)

;;; _
(provide 'judy-term)
;;; judy-term.el ends here
