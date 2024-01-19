;;; judy-dev.el --- Emacs as IDE -*- lexical-binding: t; -*-
;;; Commentary:

;; Set up dev and project management

;;; Code:

;;; General development
(require 'smartparens-config)
(smartparens-global-mode)

(add-hook 'prog-mode-hook #'turn-on-diff-hl-mode)
(add-hook 'vc-dir-mode-hook #'turn-on-diff-hl-mode)

(customize-set-variable 'compilation-scroll-output t)

;;;; Tree-Sitter/LSP
(customize-set-variable 'eglot-autoshutdown t)

(when (and (member "TREE_SITTER" (split-string system-configuration-features))
           (version< "29" emacs-version))
  (require 'treesit-auto)
  (global-treesit-auto-mode)
  (treesit-auto-install-all)
  (treesit-auto-add-to-auto-mode-alist))

;;; C/C++

(when (fboundp 'c-ts-mode)
  (customize-set-variable 'c-ts-mode-indent-offset 4))

;;; Rust
(customize-set-variable 'rust-format-on-save t)

(defun my/dev--project-find-rust-project (dir)
  "Find rust project by Cargo.toml instead of VC.
Useful when multiple rust projects reside in the same VC repo."
  (let ((override (locate-dominating-file dir "Cargo.toml")))
    (if override
        (list 'vc 'Git override)
      nil)))

(add-hook 'project-find-functions #'my/dev--project-find-rust-project)

;;; Lisp
(require 'outline)
(define-key outline-minor-mode-map (kbd "<backtab>") #'outline-cycle)

;; Add outline-minor-mode to lisp-modes
(add-hook 'emacs-lisp-mode-hook #'outline-minor-mode)
(add-hook 'lisp-mode-hook #'outline-minor-mode)
(when (boundp 'clojure-mode-hook)
  (add-hook 'clojure-mode-hook #'outline-minor-mode))

;;;; Common Lisp
(add-hook 'lisp-mode-hook #'sly-editing-mode)
(customize-set-variable 'inferior-lisp-program (if (executable-find "ros")
                                                   "ros run"
                                                 "sbcl"))

;;; Web
(with-eval-after-load 'web-mode
  (customize-set-variable 'web-mode-markup-indent-offset 2)
  (customize-set-variable 'web-mode-css-indent-offset 2)
  (customize-set-variable 'web-mode-code-indent-offset 2)
  (customize-set-variable 'web-mode-indent-style 2))

;;; _
(provide 'judy-dev)
;;; judy-dev.el ends here
