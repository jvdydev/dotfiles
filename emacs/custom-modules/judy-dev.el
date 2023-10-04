;;; judy-dev.el --- Emacs as IDE -*- lexical-binding: t; -*-
;;; Commentary:

;; Set up dev and project management

;;; Code:

;;; Spell checking
(add-hook 'after-init #'global-flycheck-mode)

(customize-set-variable 'flymake-aspell-aspell-options
                        '("--sug-mode=normal" "--lang=de"))
(add-hook 'text-mode-hook #'flymake-aspell-setup)

;;; eglot (Language Server)
;; Auto-shutdown eglot (when all associated buffers are killed)
(customize-set-variable 'eglot-autoshutdown t)

;;; Parens Helpers
(require 'smartparens-config)
(smartparens-global-mode)

;;; diff-hl
;; Highlight changes since last commit
(add-hook 'prog-mode-hook #'turn-on-diff-hl-mode)
(add-hook 'vc-dir-mode-hook #'turn-on-diff-hl-mode)

;;; Autoscroll compile buffer
(customize-set-variable 'compilation-scroll-output t)

;;; C/C++
(defun clang-format-buffer-with-config ()
  "Format current buffer using projects' .clang-format file."
  (interactive)
  (unless (project-current ".")
      (message "Unable to format buffer: No project."))
  (when (file-exists-p (expand-file-name ".clang-format" (project-root (project-current))))
    (clang-format-buffer)))

(defun clang-format-buffer-on-save ()
  "Add clang-format-buffer-with-config to before-save-hook."
  (add-hook 'before-save #'clang-format-buffer-with-config nil t))

(add-hook 'c-mode-hook #'clang-format-buffer-on-save)
(add-hook 'c++-mode-hook #'clang-format-buffer-on-save)

;;; Rust
(customize-set-variable 'rust-format-on-save t)

;; Allow project.el to find Rust projects by Cargo.toml file
(defun judy--project-find-rust-project (dir)
  "Find rust project by Cargo.toml instead of VC.
Useful when multiple rust projects reside in the same VC repo."
  (let ((override (locate-dominating-file dir "Cargo.toml")))
    (if override
        (list 'vc 'Git override)
      nil)))

(add-hook 'project-find-functions #'judy--project-find-rust-project)

;;; Lisp
(require 'outline)
(define-key outline-minor-mode-map (kbd "<backtab>") #'outline-cycle)

;; Add outline-minor-mode to lisp-modes
(add-hook 'emacs-lisp-mode-hook #'outline-minor-mode)
(add-hook 'lisp-mode-hook #'outline-minor-mode)
(add-hook 'clojure-mode-hook #'outline-minor-mode)

;;;; Common Lisp
(customize-set-variable 'inferior-lisp-program (if (executable-find "ros")
                                                   "ros run"
                                                 "sbcl"))

;;; Web-mode
(with-eval-after-load 'web-mode
  (customize-set-variable 'web-mode-markup-indent-offset 2)
  (customize-set-variable 'web-mode-css-indent-offset 2)
  (customize-set-variable 'web-mode-code-indent-offset 2)
  (customize-set-variable 'web-mode-indent-style 2))

;;; _
(provide 'judy-dev)
;;; judy-dev.el ends here
