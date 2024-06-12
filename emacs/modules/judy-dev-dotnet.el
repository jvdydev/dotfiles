;;; judy-dev-dotnet.el --- .NET Setup -*- lexical-binding: t; -*-
;;; Commentary:

;; *throws netball*

;;; Code:

;;; Packages
(when (version< "29" emacs-version)
  (add-to-list 'package-selected-packages 'csharp-mode))
(add-to-list 'package-selected-packages 'fsharp-mode)


;;; Configuration
(my/post-install-run
 (add-to-list 'auto-mode-alist '("\\.csproj\\'" . xml-mode))
 (add-to-list 'auto-mode-alist '("\\.fsproj\\'" . xml-mode))
 
 (defun my/dev--project-find-dotnet-project (dir)
   "Find .NET project by SLN file instead of VC."
   (let ((override (locate-dominating-file dir
                                           (lambda (dir)
                                             (cl-some #'identity
                                                      (mapcar
                                                       (lambda (file)
                                                         (string-match-p "*.sln" file))
                                                       (directory-files dir)))))))
     (if override
         (list 'vc 'Git override)
       nil)))
 (add-hook 'project-find-functions #'my/dev--project-find-dotnet-project))

;;; _
(provide 'judy-dev-dotnet)
;;; judy-dev-dotnet.el ends here
