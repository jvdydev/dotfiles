;;; judy-fonts.el --- Font configuration -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

(defgroup judy-font nil
  "Fonts default settings for config."
  :tag "Judy-Font"
  :group 'emacs)

(defcustom judy-fonts-default-font "JetBrains Mono"
  "Default font loaded by configuration."
  :type '(string)
  :group 'judy-font
  :set (lambda (sym val)
         (set-default sym val)
         (when (fboundp 'judy-fonts--update-font)
           (judy-fonts--update-font))))

(defcustom judy-fonts-variable-pitch-font "Iosevka Aile"
  "Variable Pitch font.
Unused."
  :type '(string)
  :group 'judy-font
  :set (lambda (sym val)
         (set-default sym val)
         (when (fboundp 'judy-fonts--update-font)
           (judy-fonts--update-font))))

(defcustom judy-fonts-default-font-size 150
  "Default font size loaded by configuration."
  :type '(integer)
  :group 'judy-font
  :set (lambda (sym val)
         (set-default sym val)
         (when (fboundp 'judy-fonts--update-font)
           (judy-fonts--update-font))))

(defun judy-fonts--update-font ()
  "Update font configuration."
  (when (x-list-fonts judy-fonts-default-font)
    (set-face-attribute 'default nil
                        :family judy-fonts-default-font
                        :height judy-fonts-default-font-size)
    (set-face-attribute 'fixed-pitch nil
                        :family judy-fonts-default-font
                        :height 1.0) ; height scaling
    (set-face-attribute 'variable-pitch nil
                        :family judy-fonts-variable-pitch-font
                        :height 1.0)) ; height scaling
  (when (x-list-fonts "Noto Color Emoji")
    (set-fontset-font t
                      (if (version< emacs-version "28.1")
                          '(#x1f300 . #x1fad0)
                        'emoji)
                      '("Noto Color Emoji" . "iso10646-1")
                      nil
                      'prepend)))

;; Ensure update is called on require if running in a window system
(when window-system
  (judy-fonts--update-font))

(provide 'judy-fonts)
;;; judy-fonts.el ends here
