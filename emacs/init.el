;;; init.el --- Configuring Emacs -*- lexical-binding: t; -*-

;;; Commentary:

;; Init loading up Crafted Emacs.

;;; Code:

;;; Custom file
(setq custom-file
      (expand-file-name ".cache/custom-vars.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file nil :nomessage))

;;; Bootstrap Crafted Emacs
(load (expand-file-name "modules/crafted-init-config.el" crafted-emacs-home))

;;; Configure packages to install
(require 'crafted-completion-packages)
(require 'crafted-evil-packages)
(require 'crafted-ide-packages)
(require 'crafted-lisp-packages)
(require 'crafted-org-packages)

;;;; Additional packages for custom modules
;; judy-keys
(add-to-list 'package-selected-packages 'general)
(add-to-list 'package-selected-packages 'which-key)

;; judy-theme
(unless (member 'modus-vivendi (custom-available-themes))
  (add-to-list 'package-selected-packages 'modus-themes))
(add-to-list 'package-selected-packages 'ef-themes)

;; judy-evil
(add-to-list 'package-selected-packages 'evil-surround)

;; judy-term
(if (member system-type '(windows-nt ms-dos))
    (add-to-list 'package-selected-packages 'powershell)
  (add-to-list 'package-selected-packages 'vterm))

;; judy-dev (also writing)
(add-to-list 'package-selected-packages 'let-alist)
(add-to-list 'package-selected-packages 'flycheck)
(add-to-list 'package-selected-packages 'flymake-aspell)

(add-to-list 'package-selected-packages 'magit)
(add-to-list 'package-selected-packages 'transient)
(add-to-list 'package-selected-packages 'xref)
(add-to-list 'package-selected-packages 'eldoc)
(add-to-list 'package-selected-packages 'smartparens)
(add-to-list 'package-selected-packages 'diff-hl)

;; Programming modes
(add-to-list 'package-selected-packages 'glsl-mode)
(add-to-list 'package-selected-packages 'clang-format)
(add-to-list 'package-selected-packages 'cmake-mode)
(add-to-list 'package-selected-packages 'rust-mode)
(add-to-list 'package-selected-packages 'web-mode)
(add-to-list 'package-selected-packages 'yaml-mode)
(add-to-list 'package-selected-packages 'scad-mode)
(add-to-list 'package-selected-packages 'arduino-mode)
(add-to-list 'package-selected-packages 'arduino-cli-mode)
(add-to-list 'package-selected-packages 'dockerfile-mode)

;;; Install packages
(package-install-selected-packages :no-confirm)

;;; Load configuration
(require 'crafted-defaults-config)
(require 'crafted-completion-config)
(require 'crafted-evil-config)
(require 'crafted-ide-config)
(crafted-ide-configure-tree-sitter '(protobuf))
(require 'crafted-lisp-config)
(require 'crafted-org-config)
(require 'crafted-startup-config)

;; Custom modules
(require 'judy-completion)
(require 'judy-defaults)
(require 'judy-dev)
(require 'judy-evil)
(require 'judy-fonts)
(require 'judy-keys)
(require 'judy-org)
(require 'judy-term)
(require 'judy-theme)
(require 'judy-transparency)
(judy-transparency-init 85)

;;; _
(provide 'init)
;;; init.el ends here
