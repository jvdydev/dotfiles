;;; judy-dev-sys-langs.el --- Systems Programming Languages -*- lexical-binding: t; -*-
;;; Commentary:

;; Setup for systems programming, including C/C++, Rust, Zig and Assembly
;; (also includes GLSL setup)

;;; Code:

;;; Packages
(add-to-list 'package-selected-packages 'c-mode)
(add-to-list 'package-selected-packages 'c++-mode)
(add-to-list 'package-selected-packages 'nasm-mode)
(add-to-list 'package-selected-packages 'zig-mode)
(add-to-list 'package-selected-packages 'rust-mode)

(add-to-list 'package-selected-packages 'glsl-mode)
(add-to-list 'package-selected-packages 'cmake-mode)

(add-to-list 'package-selected-packages 'yaml-mode) ; .clang-format

;;; Configuration
(my/post-install-run
 ;; C/C++
 (when (fboundp 'c-ts-mode)
   (customize-set-variable 'c-ts-mode-indent-offset 4))

 ;; clang-format
 (add-to-list 'auto-mode-alist '("\\.clang-format\\'" . yaml-mode))

 ;; TODO Auto-disable on windows
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

 ;; TODO Assembly

 ;; TODO Zig
 
 ;; Rust
 (customize-set-variable 'rust-format-on-save t)

 (defun my/dev--project-find-rust-project (dir)
   "Find rust project by Cargo.toml instead of VC.
Useful when multiple rust projects reside in the same VC repo."
   (let ((override (locate-dominating-file dir "Cargo.toml")))
     (if override
         (list 'vc 'Git override)
       nil)))
 (add-hook 'project-find-functions #'my/dev--project-find-rust-project))

;;; _
(provide 'judy-dev-sys-langs)
;;; judy-dev-sys-langs.el ends here
