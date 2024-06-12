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
 (add-to-list 'auto-mode-alist '("\\.csproj\\'" . xml-mode)))

;;; _
(provide 'judy-dev-dotnet)
;;; judy-dev-dotnet.el ends here
