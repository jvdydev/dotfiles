;;; judy-dev-lisp.el --- Lisp Development -*- lexical-binding: t; -*-
;;; Commentary:

;; (for (when (you (like (interactivity)))))

;;; Code:

;;; Packages
(add-to-list 'package-selected-packages 'sly)
(add-to-list 'package-selected-packages 'sly-asdf)
(add-to-list 'package-selected-packages 'sly-quicklisp)

;;; Configuration
(my/post-install-run
 ;; Folding
 (require 'outline)
 (define-key outline-minor-mode-map (kbd "<backtab>") #'outline-cycle)

 (add-hook 'emacs-lisp-mode-hook #'outline-minor-mode)
 (add-hook 'lisp-mode-hook #'outline-minor-mode)
 (when (boundp 'clojure-mode-hook)
   (add-hook 'clojure-mode-hook #'outline-minor-mode))

 ;; Common Lisp
 (add-hook 'lisp-mode-hook #'sly-editing-mode)
 (customize-set-variable 'inferior-lisp-program (if (executable-find "ros")
                                                    "ros run"
                                                  "sbcl")))

;;; _
(provide 'judy-dev-lisp)
;;; judy-dev-lisp.el ends here
