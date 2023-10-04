;;; judy-theme.el --- Theme setup (Modus Themes) -*- lexical-binding: t; -*-

;;; Commentary:
;; Various UI settings and setting up Modus Theme.
;; Basically anything (built-in) UI to modify (not: fonts, transparency).

;;; Code:

;;; init-settings

;;; Base UI
(customize-set-variable 'initial-scratch-message nil)
(scroll-bar-mode -1)   ;; Disable visible scrollbar
(tool-bar-mode -1)     ;; Disable toolbar
(tooltip-mode -1)      ;; Disable tooltips
(menu-bar-mode -1)     ;; Disable menubar
(set-fringe-mode 10)   ;; "breathing room"
(setq ring-bell-function 'ignore)

;;; Line Numbers
(defun my/disable-line-numbers ()
  "Disabling line numbers."
  (display-line-numbers-mode 0))

(column-number-mode)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)
(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                vterm-mode-hook))
  (add-hook mode #'my/disable-line-numbers))


;;; Modus Theme
;; default to dark-mode
(setq modus-theme-region '(bg-only))

(customize-set-variable 'modus-themes-italic-constructs t)
(customize-set-variable 'modus-themes-bold-constructs t)

;; Headings for related modes
(customize-set-variable 'modus-themes-headings
                        '((1 . (rainbow overline 1.4))
                          (2 . (rainbow 1.3))
                          (3 . (rainbow bold 1.2))
                          (t . (semilight 1.1))))
(setq modus-theme-scale-headings t)

(customize-set-variable 'modus-themes-org-blocks 'gray-background)
(setq modus-mixed-fonts nil)

;; general source
(customize-set-variable 'modus-themes-syntax '(yellow-comments))
(customize-set-variable 'modus-themes-lang-checkers '(straight-underline background))
(customize-set-variable 'modus-themes-paren-match '(bold))

;; Modeline
(setq modus-theme-mode-line '(accented borderless (padding . 4) (height . 0.9)))

;; Load theme
(load-theme 'modus-vivendi t)

;;; _
(provide 'judy-theme)
;;; judy-theme.el ends here
