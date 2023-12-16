;;; judy-startup.el --- Custom startup screen -*- lexical-binding: t; -*-

;;; Commentary:

;; Custom startup screen inspired by Crafted Emacs.

;;; Code:

(require 'project)
(require 'recentf)

(defun my/startup--projects (count)
  "Show COUNT many projects on startup."
  (when (file-exists-p project-list-file)
    (project--read-project-list)

    (when (and project--list (not (seq-empty-p project--list)))
      (fancy-splash-insert
       :face '(variable-pitch font-lock-string-face italic)
       "Projects:\n")

      (dolist (project (seq-take project--list count))
        (fancy-splash-insert
         :link (list (car project)
                     (lambda (_button)
                       (project-switch-project (car project))))
         "\n")))))

(defun my/startup--recentf (count)
  "Show COUNT many recently visited files."
  (when (and (boundp 'recentf-list)
             (not (seq-empty-p recentf-list)))
    (fancy-splash-insert
     :face '(variable-pitch font-lock-string-face italic)
     "Recent Files:\n")

    (dolist (file (seq-take recentf-list count))
      (fancy-splash-insert
       :link (list file
                   (lambda (_button)
                     (find-file file)))
       "\n"))))

(defun my/startup-screen ()
  "Display a startup screen."
  (let ((buffer (get-buffer-create "*Emacs*")))
    (with-current-buffer buffer
      (let ((inhibit-read-only t))
        (erase-buffer)
        (when pure-space-overflow
          (insert pure-space-overflow-message))

        (insert "\n\n")
        (fancy-splash-insert "Emacs")
        (center-region (point-min) (point-max))

        (insert "\n\n")
        (my/startup--projects 5)
        (insert "\n\n")
        (my/startup--recentf 5)
        (insert "\n"))
      (read-only-mode 1))
    (switch-to-buffer buffer)))

(defun my/use-custom-startup-screen ()
  "Use the customized startup screen as initial startup."
  (setq initial-buffer-choice #'my/startup-screen))

;;; _
(provide 'judy-startup)
;;; judy-startup.el ends here
