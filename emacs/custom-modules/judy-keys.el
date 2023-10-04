;;; judy-keys.el --- Keyboard config -*- lexical-binding: t; -*-
;;; Commentary:

;; Keyboard and shortcuts

;;; Code:

;;; Global keybindings
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;;; which-key
(which-key-mode)
(setq which-key-idle-delay nil)

;;; general.el
(with-eval-after-load 'evil
  (general-evil-setup t))

;;;; General Definer
(general-create-definer judy-leader-keys
                        :keymaps '(normal insert visual emacs)
                        :prefix "SPC")
;;;; Leader-Map
(judy-leader-keys
  "b" '(:ignore t :which-key "buffer")
  "bb" '(switch-to-buffer :which-key "Switch to buffer")
  "be" '(eval-buffer :which-key "Evaluate current buffer")
  "bk" '(kill-current-buffer :which-key "Kill the current Buffer")
  "<" '(switch-to-buffer :which-key "Switch to buffer")

  "d" '(:ignore t :which-key "Dired")
  "dd" '(dired :which-key "Dired")

  "f" '(:ignore t :which-key "files")
  "ff" '(find-file :which-key "Find file")

  "g" '(:ignore t :which-key "git")
  "gs" '(magit-status :which-key "Open magit status for current repo")

  "p" '(:ignore t :which-key "programming")
  "pm" '(evil-make :which-key "evil-make")
  "pe" '(eglot :which-key "Start eglot")
  "pr" '(eglot-rename :which-key "rename")
  "pd" '(eldoc-doc-buffer :which-key "doc"))

(provide 'judy-keys)
;;; judy-keys.el ends here
