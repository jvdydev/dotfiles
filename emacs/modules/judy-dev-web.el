;;; judy-dev-web.el --- Web-Dev in Emacs -*- lexical-binding: t; -*-
;;; Commentary:

;; For when you have to subject yourself to web development.

;;; Code:

;;; Packages
(add-to-list 'package-selected-packages 'web-mode)
(add-to-list 'package-selected-packages 'js2-mode)
(add-to-list 'package-selected-packages 'typescript-mode)
(add-to-list 'package-selected-packages 'ng2-mode)

(add-to-list 'package-selected-packages 'dockerfile-mode)
(add-to-list 'package-selected-packages 'docker-compose-mode)
(add-to-list 'package-selected-packages 'yaml-mode)

;;; Configuration
(my/post-install-run
 (with-eval-after-load 'web-mode
   (customize-set-variable 'web-mode-markup-indent-offset 2)
   (customize-set-variable 'web-mode-css-indent-offset 2)
   (customize-set-variable 'web-mode-code-indent-offset 2)
   (customize-set-variable 'web-mode-indent-style 2))

 (customize-set-variable 'css-indent-offset 2)
 (add-to-list 'auto-mode-alist '("\\.[s]?css\\'" . web-mode))

 (defun my/dev--project-find-web-project (dir)
   "Find java-/typescript project by package.json instead of VC."
   (let ((override (locate-dominating-file dir "package.json")))
     (if override
         (list 'vc 'Git override)
       nil)))
 (add-hook 'project-find-functions #'my/dev--project-find-web-project)
 )

;;; _
(provide 'judy-dev-web)
;;; judy-dev-web.el ends here
