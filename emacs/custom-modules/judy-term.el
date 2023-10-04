;;; judy-term.el --- Terminal and Shell configuration -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:
(defconst judy-term--is-windows (member system-type '(windows-nt ms-dos))
  "Is current runtime MS Windows?")

;; Linux/BSD, ...
(unless judy-term--is-windows
  ;; term-mode
  (setq explicit-shell-file-name "bash")
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")

  ;; TODO eshell

  ;; vterm
  (setq vterm-max-scrollback 10000))

;; Windows ...
(when judy-term--is-windows
  ;; term
  (setq explicit-shell-file-name "powershell")

  ;; TODO eshell
  )

;;; _
(provide 'judy-term)
;;; judy-term.el ends here
