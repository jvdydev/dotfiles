;;; judy-ui.el --- All things UI -*- lexical-binding: t; -*-

;;; Commentary:

;; UI settings.

;; Known issues:
;; - Running as daemon will not change the window transparency of all clients.

;;; Code:

;;; General UI
(customize-set-variable 'initial-scratch-message nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
(setq ring-bell-function 'ignore)

;;;; Line Numbers
(defun my/disable-line-numbers ()
  "Disabling line numbers."
  (display-line-numbers-mode -1))

(column-number-mode)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)
(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                vterm-mode-hook))
  (add-hook mode #'my/disable-line-numbers))

;;; Modus Theme
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

;;; Fonts
(defconst my/default-font "JetBrains Mono"
  "Default font (monospace).")

(defconst my/default-vp-font "Iosevka Aile"
  "Default variable pitch font.")

(defconst my/default-font-size 150
  "Default font size.")

;;;; Current
(defvar my/current-font my/default-font
  "Current font.")

(defvar my/current-font-size my/default-font-size
  "Current font size.")

(defvar my/current-vp-font my/default-vp-font
  "Current variable pitch font.")

;;;; Update function
(defun my/fonts-update ()
  "Update font configuration.
Rerun after setting any font variables."
  (when (and window-system (x-list-fonts my/current-font))
    (set-face-attribute 'default nil
                        :family my/current-font
                        :height my/current-font-size)
    (set-face-attribute 'fixed-pitch nil
                        :family my/current-font
                        :height 1.0)
    (set-face-attribute 'variable-pitch nil
                        :family my/current-vp-font
                        :height 1.0))
  ;; optional Emoji font
  (when (and window-system (x-list-fonts "Noto Color Emoji"))
    (set-fontset-font t
                      (if (version< emacs-version "28.1")
                          '(#x1f300 . #x1fad0)
                        'emoji)
                      '("Noto Color Emoji" . "iso10646-1")
                      nil
                      'prepend)))

(defun my/initialize-fonts (size)
  "Initialize font with SIZE."
  (setq my/current-font-size size)
  (my/fonts-update))

;;; Transparency
;; Small transparency submodule with interactive functions.

(defvar my/transparency-current-value 85
  "Current transparency %.")
(defvar my/transparency-current-state nil
  "Current state of transparency.")

(defun my/transparency--update (frame)
  "Update transparency in `FRAME'."
  (if my/transparency-current-state
      (set-frame-parameter frame
                           'alpha-background
                           my/transparency-current-value)
  (set-frame-parameter frame
                       'alpha-background
                       100)))

(defun my/transparency-init (opacity)
  "Initialize and dispatch transparency for either daemon or instance."
  (setq my/transparency-current-value opacity)
  (setq my/transparency-current-state t)
  (if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (with-selected-frame frame
                    (my/transparency--update frame))))
    (my/transparency--update (selected-frame))))

;;;; Interactive functions
(defun my/transparency-set (transparency)
  "Set 'TRANSPARENCY' percentage interactively."
  (interactive "nTransparency: ")
  ;; Valid Range: 1-100
  (unless (and (>= transparency 1)
               (<= transparency 100))
    (user-error "Unable to set transparency percentage"))
  (when my/transparency-current-state
    (setq my/transparency-current-value transparency)
    (my/transparency--update (selected-frame))))

(defun my/transparency-toggle ()
  "Toggle transparency for current frame."
  (interactive)
  (setq my/transparency-current-state
        (not my/transparency-current-state))
  (my/transparency--update (selected-frame)))

;;; _
(provide 'judy-ui)
;;; judy-ui.el ends here
