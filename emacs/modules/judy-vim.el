;;; judy-vim.el --- Vim, but in Emacs -*- lexical-binding: t; -*-

;;; Commentary:

;; Everything related to vim-like behaviour in Emacs.
;; Includes leader key setup using general.

;;; Code:

;;; Packages


;;;; evil
(add-to-list 'package-selected-packages 'evil)
(add-to-list 'package-selected-packages 'evil-collection)
(add-to-list 'package-selected-packages 'evil-surround)

;; Leader Key setup
(add-to-list 'package-selected-packages 'general)
(add-to-list 'package-selected-packages 'which-key)

;;; Config
(my/post-install-run
 ;; evil settings
 (customize-set-variable 'evil-want-integration t)
 (customize-set-variable 'evil-want-keybinding nil)
 (customize-set-variable 'evil-want-C-i-jump nil)
 (customize-set-variable 'evil-respect-visual-line-mode t)
 (customize-set-variable 'evil-want-C-h-delete t)
 (customize-set-variable 'evil-want-fine-undo t)
 (customize-set-variable 'evil-respect-visual-line-mode t)
 (customize-set-variable 'evil-want-abbrev-expand-on-insert-exit nil)
 (customize-set-variable 'evil-undo-system 'undo-redo)

 ;; load evil
 (require 'evil)
 (evil-mode 1)

 ;; Set up search
 (evil-select-search-module 'evil-search-module 'evil-search)

 ;; Set default mode for system text buffers to normal mode
 (evil-set-initial-state 'messages-buffer-mode 'normal)
 (evil-set-initial-state 'dashboard-mode 'normal)

 ;; evil-collection
 (evil-collection-init)

 ;; evil-surround
 (defun my/evil-org-additional-surround-pairs ()
   "Additional surround pairs for evil-surround in org-mode."
   (push '(?| . ("| " . " |")) evil-surround-pairs-alist))

 (add-hook 'org-mode-hook #'my/evil-org-additional-surround-pairs)
 (global-evil-surround-mode t)

 ;; Leader setup (which-key/general)
 (which-key-mode)
 (customize-set-variable 'which-key-idle-delay nil)
 (general-evil-setup t)

 ;; Leader Map
 (general-create-definer judy-leader-key
   :keymaps '(normal insert visual emacs)
   :prefix "SPC"
   :global-prefix "M-SPC")

 (defun my/dired-current-buffer ()
   "Open dired in the current buffer.
This is equivalent to running \":Ex\" in vim to open netrw."
   (interactive)
   (dired "."))

 (defun my/switch-to-term-or-shell ()
   "Switch to a shell buffer."
   (interactive)
   (switch-to-buffer
    (completing-read "Shell Buffer: "
                     (mapcar #'buffer-name
                             (cl-remove-if-not (lambda (b)
                                                 (member (buffer-local-value 'major-mode b)
                                                         '(eshell-mode shell-mode vterm-mode term-mode)))
                                               (buffer-list))))))

 (judy-leader-key
   "b" '(:ignore t :which-key "buffer")
   "bs" '(switch-to-buffer :which-key "Switch to buffer")
   "bk" '(kill-current-buffer :which-key "Kill the current Buffer")

   "d" '(:ignore t :which-key "Dired")
   "dd" '(my/dired-current-buffer :which-key "Current directory")
   "df" '(dired :which-key "Find directory")

   "f" '(:ignore t :which-key "find")
   "ff" '(find-file :which-key "Find file")
   "fd" '(dired :which-key "Find directory")
   "fp" '(project-find-file :which-key "Find file (project)")
   "fr" '(consult-ripgrep :which-key "ripgrep")

   "g" '(:ignore t :which-key "git")
   "gs" '(magit-status :which-key "Open magit status for current repo")

   "s" '(:ignore t :which-key "Switching")
   "sb" '(switch-to-buffer :which-key "Switch to buffer")
   "st" '(my/switch-to-term-or-shell :which-key "Switch to term/shell")

   "t" '(:ignore t :which-key "terms and shells")
   "te" '(eshell :which-key "Open EShell")
   "tv" '(vterm :which-key "Open vterm")
   "ta" '(async-shell-command :which-key "Async shell command")
   "tc" '(compile :which-key "Async shell command")

   "o" '(:ignore t :which-key "org-mode")
   "od" '(org-agenda :which-key "org-agenda dispatch")
   "or" '(org-refile :which-key "refile")
   "oa" '(org-archive-subtree :which-key "archive subtree")

   "p" '(:ignore t :which-key "programming")
   "pm" '(evil-make :which-key "evil-make")
   "pe" '(eglot :which-key "Start eglot")
   "pr" '(eglot-rename :which-key "rename")
   "pf" '(project-find-file :which-key "Find file"))

 ;; vertico
 (with-eval-after-load 'vertico
   (keymap-set vertico-map "C-j" #'vertico-next)
   (keymap-set vertico-map "C-k" #'vertico-previous))

 ;; corfu
 (with-eval-after-load 'corfu
   (keymap-set corfu-map "C-j" #'corfu-next)
   (keymap-set corfu-map "C-k" #'corfu-previous))

 ;; org-mode
 (with-eval-after-load 'org-mode
   (keymap-set org-mode-map (kbd "C-j") #'org-next-visible-heading)
   (keymap-set org-mode-map (kbd "C-k") #'org-previous-visible-heading))

 ;; Rebind universal argument
 (global-set-key (kbd "C-M-u") #'universal-argument)

 ;; Make C-g and <escape> mutually agree
 (keymap-set evil-insert-state-map "C-g" #'evil-normal-state)
 (global-set-key (kbd "<escape>") #'keyboard-escape-quit))


;;; _
(provide 'judy-vim)
;;; judy-vim.el ends here
