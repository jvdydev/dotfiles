;;; judy-term.el --- Term and Shell configuration -*- lexical-binding: t; -*-
;;; Commentary:

;; Terminal > GUI

;;; Code:

;;; Packages
(unless-windows
 (add-to-list 'package-selected-packages 'vterm))

;;; Configuration
(my/post-install-run
 (unless-windows
  (setq explicit-shell-file-name "bash")
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  (setq vterm-max-scrollback 10000))

 (require 'eshell))

;;; _
(provide 'judy-term)
;;; judy-term.el ends here
