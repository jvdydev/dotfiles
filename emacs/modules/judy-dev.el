;;; judy-dev.el --- Emacs as IDE -*- lexical-binding: t; -*-
;;; Commentary:

;; Set up dev and project management

;;; Code:

;;; General development
(require 'smartparens-config)
(smartparens-global-mode)

(add-hook 'prog-mode-hook #'turn-on-diff-hl-mode)
(add-hook 'vc-dir-mode-hook #'turn-on-diff-hl-mode)

(defun my/eglot-disable-inlay-hints (_ignored)
  "Disable eglot inlay hints mode."
  (eglot-inlay-hints-mode -1))

(customize-set-variable 'compilation-scroll-output t)
(add-hook 'eglot-connect-hook #'my/eglot-disable-inlay-hints)

;;;; Tree-Sitter/LSP
(customize-set-variable 'eglot-autoshutdown t)

(when (and (member "TREE_SITTER" (split-string system-configuration-features))
           (version< "29" emacs-version))
  (require 'treesit-auto)
  (global-treesit-auto-mode)
  (treesit-auto-install-all)
  (treesit-auto-add-to-auto-mode-alist))

;;;; DAP (dape)
(when (require 'dape)
  (when (executable-find "dlv")
    (add-to-list 'dape-configs
                 '(delve
                   modes (go-mode go-ts-mode)
                   command "dlv"
                   command-args ("dap" "--listen" "127.0.0.1:55878")
                   command-cwd dape-cwd-fn
                   host "127.0.0.1"
                   port 55878
                   :type "debug"
                   :request "launch"
                   :cwd dape-cwd-fn
                   :program dape-cwd-fn))))

;;; C/C++
(defun clang-format-buffer-with-config ()
  "Format current buffer using projects' .clang-format file."
  (interactive)
  (when (and (member major-mode '(c-mode c-ts-mode c++-mode c++-ts-mode))
             (project-current)
             (file-exists-p (expand-file-name ".clang-format"
                                              (project-root (project-current)))))
    (clang-format-buffer)))

(add-hook 'before-save #'clang-format-buffer-with-config)

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
