;;; judy-transparency.el --- Interactively set transparency  -*- lexical-binding: t; -*-

;;; Commentary:
;; Provide simple transparency implementation with interactive utils.

;; Known Issues:
;; - Running as daemon will not change the window transparency of all clients.

;;; Code:

(defgroup transparency nil
  "Transparency default settings."
  :tag "Transparency"
  :group 'emacs)

(defcustom judy-transparency-startup-value 85
  "Default Transparency value.
Is only used if judy-transparency-enable-on-startup is t."
  :type '(integer)
  :group 'transparency
  :set (lambda (sym val)
         (cond
          ((> val 100) (set-default sym 100))
          ((< val 0) (set-default sym 0))
          (t (set-default sym val)))))

(defcustom judy-transparency-enable-on-startup t
  "Enable Transparency when starting Emacs."
  :type '(boolean)
  :group 'transparency)

(defvar judy-transparency-current-value judy-transparency-startup-value)
(defvar judy-transparency-current-state judy-transparency-enable-on-startup)


(defun judy-transparency--update (frame)
  "Update transparency in 'FRAME'."
  (if judy-transparency-current-state
      (set-frame-parameter frame
                           'alpha-background
                           judy-transparency-current-value)
  (set-frame-parameter frame
                       'alpha-background
                       100)))

(defun judy-transparency-set (transparency)
  "Set 'TRANSPARENCY' percentage interactively."
  (interactive "nTransparency: ")
  ;; Valid Range: 1-100
  (unless (and (>= transparency 1)
               (<= transparency 100))
    (error "Unable to set transparency percentage"))
  (setq judy-transparency-current-value transparency)
  (set-frame-parameter (selected-frame) 'alpha-background judy-transparency-current-value))

(defun judy-transparency-toggle ()
  "Toggle transparency for current frame."
  (interactive)
  (setq judy-transparency-current-state (not judy-transparency-current-state))
  (judy-transparency--update (selected-frame)))

;; TODO optionally update *all* frames
(defun judy-transparency-toggle-all ()
  "Toggle transparency for all (connected) frames.
Useful when running Emacs as a daemon.")

(defun judy-transparency-init (opacity)
  "Initialize and dispatch transparency for either daemon or instance."
  (customize-set-variable 'judy-transparency-enable-on-startup t)
  (customize-set-variable 'judy-transparency-startup-value opacity)
  (if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (with-selected-frame frame
                    (judy-transparency--update frame))))
    (judy-transparency--update (selected-frame))))

(provide 'judy-transparency)
;;; judy-transparency.el ends here.
