;;; init.el --- Configuring Emacs -*- lexical-binding: t; -*-

;;; Commentary:

;; Init loading up Crafted Emacs.

;;; Code:

;;; Custom file
(setq custom-file
      (expand-file-name ".cache/custom-vars.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file nil :nomessage))

;;; Helper macros
(defmacro unless-windows (&rest body)
  "Like `unless', but condition is always system type being windows."
  `(unless (member system-type '(windows-nt ms-dos))
    ,@body))

;;; Packages

;;;; Pre-Emacs 29 compat
(when (and (version< emacs-version "29")
           (not (require 'compat nil :noerror))
           (add-to-list 'package-selected-packages 'compat)))

;;;; evil
(add-to-list 'package-selected-packages 'evil)
(add-to-list 'package-selected-packages 'evil-collection)
(add-to-list 'package-selected-packages 'evil-surround)

;; Leader Key setup
(add-to-list 'package-selected-packages 'general)
(add-to-list 'package-selected-packages 'which-key)

;;;; Completion
(add-to-list 'package-selected-packages 'cape)
(add-to-list 'package-selected-packages 'consult)
(add-to-list 'package-selected-packages 'consult-git-log-grep)
(add-to-list 'package-selected-packages 'corfu)
(add-to-list 'package-selected-packages 'corfu-terminal)
(add-to-list 'package-selected-packages 'vertico)
(add-to-list 'package-selected-packages 'marginalia)
(add-to-list 'package-selected-packages 'orderless)

;;;; General development
(add-to-list 'package-selected-packages 'magit)
(add-to-list 'package-selected-packages 'smartparens)
(add-to-list 'package-selected-packages 'diff-hl)

;;;; New modes
;; Langs
(add-to-list 'package-selected-packages 'rust-mode)
(add-to-list 'package-selected-packages 'go-mode)
(add-to-list 'package-selected-packages 'scad-mode)

;; C/C++
(add-to-list 'package-selected-packages 'c-mode)
(add-to-list 'package-selected-packages 'c++-mode)
(add-to-list 'package-selected-packages 'cmake-mode)

;; Graphics
(add-to-list 'package-selected-packages 'glsl-mode)

;;;; Lisp
(add-to-list 'package-selected-packages 'sly)
(add-to-list 'package-selected-packages 'sly-asdf)
(add-to-list 'package-selected-packages 'sly-quicklisp)

;; Data and notes
(add-to-list 'package-selected-packages 'yaml-mode)
(add-to-list 'package-selected-packages 'markdown-mode)
(add-to-list 'package-selected-packages 'hl-todo)

;; Web
(add-to-list 'package-selected-packages 'web-mode)
(add-to-list 'package-selected-packages 'js2-mode)
(add-to-list 'package-selected-packages 'typescript-mode)
(add-to-list 'package-selected-packages 'ng2-mode)

;; .NET
(when (version< "29" emacs-version)
  (add-to-list 'package-selected-packages 'csharp-mode))

;; Docker/Podman
(add-to-list 'package-selected-packages 'dockerfile-mode)
(add-to-list 'package-selected-packages 'docker-compose-mode)

;;;; Treesitter
(when (member "TREE_SITTER" (split-string system-configuration-features))
  (if (version< "29" emacs-version)
      (add-to-list 'package-selected-packages 'treesit-auto)
    (progn
      (add-to-list 'package-selected-packages 'tree-sitter)
      (add-to-list 'package-selected-packages 'tree-sitter-indent)
      (add-to-list 'package-selected-packages 'tree-sitter-ispell)
      (add-to-list 'package-selected-packages 'tree-sitter-langs))))

;;;; eglot (Pre-Emacs 29)
(when (version< emacs-version "29")
  (add-to-list 'package-selected-packages 'eglot))

;;;; org
(add-to-list 'package-selected-packages 'org-appear)

;;;; Themes
(unless (member 'modus-vivendi (custom-available-themes))
  (add-to-list 'package-selected-packages 'modus-themes))
(add-to-list 'package-selected-packages 'ef-themes)

;;;; Terminal
(unless-windows
  (add-to-list 'package-selected-packages 'vterm))

;;; Install packages
(customize-set-variable 'package-install-upgrade-built-in t)
(package-install-selected-packages :no-confirm)

;;; Configuration
;;;; Visual configuration
(require 'judy-ui)
(my/initialize-fonts 250)
(unless-windows
  (my/transparency-init 85))

;; Custom startup screen
(require 'judy-startup)
(my/use-custom-startup-screen)

;;;; General editor config
(require 'judy-defaults)
(require 'judy-vim)
(require 'judy-completion)

;; Dev, note-taking and terms
(global-hl-todo-mode)
(require 'judy-term)
(require 'judy-notes)
(require 'judy-dev)

;;; _
(provide 'init)
;;; init.el ends here
