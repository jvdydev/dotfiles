;;; early-init.el --- Early initialisation -*- lexical-binding: t; -*-

;;; Commentary:

;; Early init.
;; Set up deferred native compilation, packages, dark-theme by default and GC opts.

;;; Code:

;;; Garbage Collection/Startup Message
(setq gc-cons-threshold most-positive-fixnum)

(defun my/post-startup ()
  "Sets GC threshold and displays load-time message."
  (setq gc-cons-threshold (* 20 1000 1000))
  (message "Emacs loaded (%s seconds)" (emacs-init-time "%.2f")))

(add-hook 'emacs-startup-hook #'my/post-startup)

;;; package.el
(require 'package)

(when (version< emacs-version "28")
  (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(add-to-list 'package-archives '("stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(customize-set-variable 'package-archive-priorities
                        '(("gnu"    . 99)
                          ("nongnu" . 80)
                          ("stable" . 70)
                          ("melpa"  . 0)))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;;; (Native) Compilation and loading
(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors nil)
  (setq native-comp-deferred-compilation t)
  (add-to-list 'native-comp-eln-load-path
               (expand-file-name ".cache/eln-cache/"
                                 user-emacs-directory)))

(customize-set-variable 'load-prefer-newer t)

;;; Modules
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;;; Load a dark theme to avoid flashing on load
;; On Emacs 28+: Modus Themes is built-in and loaded, otherwise deeper-blue
(if (member 'modus-vivendi (custom-available-themes))
    (load-theme 'modus-vivendi t)
  (load-theme 'deeper-blue t))

;;; _
(provide 'early-init)
;;; early-init.el ends here
