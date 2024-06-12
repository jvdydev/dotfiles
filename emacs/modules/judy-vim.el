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

 (defun my/switch-to-buffer-by-predicate (prompt predicate)
   "Switch to a buffer with interactive selection.
The list is pre-filtered by `predicate'."
   (switch-to-buffer
    (completing-read prompt
                     (mapcar #'buffer-name
                             (cl-remove-if-not predicate (buffer-list))))))
 
 (defun my/switch-to-term-or-shell ()
   "Switch to a shell buffer."
   (interactive)
   (my/switch-to-buffer-by-predicate
    "Shell Buffer: "
     (lambda (b)
       (member (buffer-local-value 'major-mode b)
               '(eshell-mode shell-mode vterm-mode term-mode)))))

 (defun my/switch-to-magit-status ()
    "Switch to a magit-status buffer."
    (interactive)
    (my/switch-to-buffer-by-predicate
     "magit Buffer: "
     (lambda (b)
       (eq (buffer-local-value 'major-mode b)
           'magit-status-mode))))

 (defun my/compile ()
   "Call `recompile' if available or `compile' otherwise."
   (interactive)
   (if (fboundp 'recompile)
       (recompile)
     (call-interactively #'compile)))

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
   "gb" '(my/switch-to-magit-status :which-key "Switch to open magit buffer")

   "t" '(:ignore t :which-key "terms and shells")
   "te" '(eshell :which-key "Open EShell")
   "tv" '(vterm :which-key "Open vterm")
   "ta" '(async-shell-command :which-key "Async shell command")
   "ts" '(my/switch-to-term-or-shell :which-key "Switch to term/shell")

   "o" '(:ignore t :which-key "org-mode")
   "od" '(org-agenda :which-key "org-agenda dispatch")
   "or" '(org-refile :which-key "refile")
   "oa" '(org-archive-subtree :which-key "archive subtree")

   "p" '(:ignore t :which-key "programming")
   "pm" '(my/compile :which-key "(re-)compile")
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
