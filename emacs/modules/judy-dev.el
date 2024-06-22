;;; judy-dev.el --- Emacs as IDE -*- lexical-binding: t; -*-
;;; Commentary:

;; General development setup

;;; Code:

;;; Packages
(add-to-list 'package-selected-packages 'magit)
(add-to-list 'package-selected-packages 'smartparens)
(add-to-list 'package-selected-packages 'diff-hl)

(when (member "TREE_SITTER" (split-string system-configuration-features))
  (if (version< "29" emacs-version)
      (add-to-list 'package-selected-packages 'treesit-auto)
    (progn
      (add-to-list 'package-selected-packages 'tree-sitter)
      (add-to-list 'package-selected-packages 'tree-sitter-indent)
      (add-to-list 'package-selected-packages 'tree-sitter-ispell)
      (add-to-list 'package-selected-packages 'tree-sitter-langs))))

(when (version< emacs-version "29")
  (add-to-list 'package-selected-packages 'eglot))

;;; Configuration
(my/post-install-run
 ;; Parens managment
 (require 'smartparens-config)
 (smartparens-global-mode)

 ;; Mark current line
 (add-hook 'prog-mode-hook #'turn-on-diff-hl-mode)
 (add-hook 'vc-dir-mode-hook #'turn-on-diff-hl-mode)

 ;; auto-scroll compile buffer
 (customize-set-variable 'compilation-scroll-output t)

 ;; Use magit-show-commit to display diffs
 (customize-set-variable 'consult-git-log-grep-open-function #'magit-show-commit)

 ;; Tree-Sitter/LSP
 (customize-set-variable 'eglot-autoshutdown t)
 (customize-set-variable 'eglot-ignored-server-capabilities '(:inlayHintProvider))

 (when (and (member "TREE_SITTER" (split-string system-configuration-features))
            (version< "29" emacs-version))
   (require 'treesit-auto)
   (global-treesit-auto-mode)
   (treesit-auto-install-all)
   (treesit-auto-add-to-auto-mode-alist))

 ;; CTAGS
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
       (user-error "Not in a project")))))

;;; _
(provide 'judy-dev)
;;; judy-dev.el ends here
