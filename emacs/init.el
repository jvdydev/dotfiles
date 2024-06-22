;;; init.el --- Configuring Emacs -*- lexical-binding: t; -*-

;;; Commentary:

;; Init loading up Crafted Emacs.

;;; Code:

;;; Helper macros
(defmacro unless-windows (&rest body)
  "Like `unless', but condition is always system type being windows."
  `(unless (member system-type '(windows-nt ms-dos))
     ,@body))

(defmacro when-windows (&rest body)
  "Like `when', but condition is always system type being windows."
  `(when (member system-type '(windows-nt ms-dos))
     ,@body))

(defmacro ensure-tool-present (tool)
  "Ensure TOOL is installed and available on PATH.
Otherwise, show a `user-error'."
  `(unless (executable-find ,tool)
     (user-error "Please install the %s application (and ensure it's on PATH)" ,tool)))

;;; Post-install hooks
(defvar my/post-install-setup nil
  "List of functions to call post-installation of packages.")

(defmacro my/post-install-run (&rest body)
  "Add body to `my/post-install-setup' functions."
  `(add-to-list 'my/post-install-setup
                (list
                 :file ,load-file-name
                 :function (lambda () ,@body))))

;;; Defaults
(require 'judy-defaults)

;;; Init
;;;; Load modules
(require 'judy-vim)
(require 'judy-completion)
(require 'judy-ui)
(require 'judy-notes)
(require 'judy-term)

(require 'judy-startup)

;; Dev Modules
(require 'judy-dev)
(require 'judy-dev-sys-langs)
(require 'judy-dev-lisp)
(require 'judy-dev-dotnet)
(require 'judy-dev-web)
(require 'judy-dev-misc)

;;;; package-install
(customize-set-variable 'package-install-upgrade-built-in t)
(package-install-selected-packages :no-confirm)

;;;; run configurations
(dolist (runner (reverse my/post-install-setup))
  (message "Running config for %s" (plist-get runner :file))
  (funcall (plist-get runner :function)))

;;;; Customizations to adjust per-setup
(my/initialize-fonts 250)
(unless-windows
 (my/transparency-init 85))

(my/use-custom-startup-screen)

;;; _
(provide 'init)
;;; init.el ends here
