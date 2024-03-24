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

;; Use magit-show-commit to display diffs
(customize-set-variable 'consult-git-log-grep-open-function #'magit-show-commit)

;;;; Tree-Sitter/LSP
(customize-set-variable 'eglot-autoshutdown t)
(add-hook 'before-save-hook #'eglot-format-buffer)

;; Disable inlay hints
(customize-set-variable 'eglot-ignored-server-capabilities '(:inlayHintProvider))

(when (and (member "TREE_SITTER" (split-string system-configuration-features))
           (version< "29" emacs-version))
  (require 'treesit-auto)
  (global-treesit-auto-mode)
  (treesit-auto-install-all)
  (treesit-auto-add-to-auto-mode-alist))

;;;; CTAGS
(defun build-ctags ()
  "Build CTAGS for the current project."
  (interactive)
  (ensure-tool-present "ctags")
  (let ((default-directory (project-root (project-current)))
        ;; Avoid async-shell-command buffer ruining the layout here
        (display-buffer-alist (list (cons "\\*Async Shell Command\\*.*"
                                          (cons #'display-buffer-no-window nil)))))
    (if default-directory
        (async-shell-command "ctags -e -R")
        (user-error "Not in a project"))))

;;; C/C++
(add-to-list 'auto-mode-alist '("\\.clang-format\\'" . yaml-mode))

(when (fboundp 'c-ts-mode)
  (customize-set-variable 'c-ts-mode-indent-offset 4))

(defun clang-format-project ()
  "Format everything in the current project using clang-format."
  (interactive)
  (ensure-tool-present "find")
  (ensure-tool-present "xargs")
  (ensure-tool-present "clang-format")
  (let ((default-directory (project-root (project-current)))
        (display-buffer-alist (list (cons "\\*Async Shell Command\\*.*"
                                          (cons #'display-buffer-no-window nil)))))
    (save-some-buffers nil (lambda () (string-equal (project-root (project-current)) default-directory)))
    (if default-directory
        (async-shell-command "find . -type f -iname *.c -o -iname *.h -o -iname *.cpp | xargs clang-format -i")
        (user-error "Not in a project"))))

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

;;; ML languages
;;;; OCaml
(add-to-list 'load-path "/home/judy/.opam/default/share/emacs/site-lisp")
(require 'ocp-indent)
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(ocaml-ts-mode . ("ocamllsp" "--stdio"))))

;;;; FSharp

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

(customize-set-variable 'css-indent-offset 2)
(add-to-list 'auto-mode-alist '("\\.[s]?css\\'" . web-mode))

;;; C#
(add-to-list 'auto-mode-alist '("\\.csproj\\'" . xml-mode))

;;; _
(provide 'judy-dev)
;;; judy-dev.el ends here
