;;; judy-evil.el --- EVIL module -*- lexical-binding: t; -*-

;;; Commentary:

;; Mainly evil-surround

;;; Code:

;;; more motions
;; Use Ctrl + vim-up/down to move between headings in org-mode
(evil-define-key '(normal insert visual) org-mode-map (kbd "C-j") 'org-next-visible-heading)
(evil-define-key '(normal insert visual) org-mode-map (kbd "C-k") 'org-previous-visible-heading)

;; Rebind universal argument
(global-set-key (kbd "C-M-u") 'universal-argument)

;; Add binding for ESC
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Set default mode for system text buffers to normal mode
(evil-set-initial-state 'messages-buffer-mode 'normal)
(evil-set-initial-state 'dashboard-mode 'normal)

;; Some defaults
(customize-set-variable 'evil-respect-visual-line-mode t)
(customize-set-variable 'evil-want-abbrev-expand-on-insert-exit nil)

;;; evil-surround
(defun my/evil-org-additional-surround-pairs ()
  "Additional surround pairs for evil-surround in org-mode."
  (push '(?| . ("| " . " |")) evil-surround-pairs-alist))

(add-hook 'org-mode-hook #'my/evil-org-additional-surround-pairs)
(global-evil-surround-mode t)

;;; _
(provide 'judy-evil)
;;; judy-evil.el ends here
