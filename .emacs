;;; -*- lexical-binding: t -*-

(add-to-list 'exec-path "/opt/homebrew/bin")

(when (not (member "~/.emacs.d/emacs-eat" load-path))
  (push "~/.emacs.d/emacs-eat" load-path)
  (require 'eat)
  (delete [C-left] eat-semi-char-non-bound-keys)
  (delete [C-right] eat-semi-char-non-bound-keys)
  (eat-update-semi-char-mode-map)
  (eat-reload))

(when (not (member "~/.emacs.d/terraform-mode" load-path))
  (push "~/.emacs.d/terraform-mode" load-path)
  (require 'terraform-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(context-menu-mode t)
 '(custom-enabled-themes '(modus-operandi-tinted))
 '(dired-listing-switches "-ahl")
 '(display-time-mode t)
 '(eat-kill-buffer-on-exit t)
 '(eat-term-name "xterm-256color")
 '(eat-tramp-shells '(("docker" . "/bin/sh") ("ssh" . "/bin/bash")))
 '(global-whitespace-mode t)
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(magit-diff-refine-hunk t)
 '(magit-process-connection-type nil)
 '(org-agenda-files '("~/_jsgosh/agenda"))
 '(package-selected-packages '(magit markdown-mode meow))
 '(scroll-conservatively 101)
 '(tab-bar-mode t)
 '(tool-bar-mode nil)
 '(whitespace-line-column 120)
 '(whitespace-style '(face trailing tabs lines)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(global-set-key (kbd "C-c a") #'org-agenda)

(with-eval-after-load "dired"
  (define-key dired-mode-map [mouse-2] 'dired-mouse-find-file))

(with-eval-after-load "eglot"
  (add-to-list 'eglot-server-programs
               '(terraform-mode . ("tofu-ls" "serve"))))

(defun js-date (region-start region-end)
  "Mostly equivalent to JavaScript's `new Date(value)', assuming
the text content of the selected REGION consists of a single VALUE
representing the number of milliseconds since the Unix epoch."
  (interactive "r")
  (let* ((timestamp (string-to-number
                     (buffer-substring-no-properties region-start region-end)))
         (time (/ timestamp 1000)))
    (message (format-time-string "%a %b %d %Y %T %z (%Z)" time))))


;;; MEOW

(require 'meow)
(meow-global-mode 1)

(defun enable-delete-selection-mode ()
  (delete-selection-mode)
  (setq-local delete-active-region t))

(defun disable-delete-selection-mode ()
  "Just in case `meow-insert-exit-hook' is ever called
outside `meow-insert-mode'."
  (delete-selection-mode -1)
  (setq-local delete-active-region nil))

(defun meow-insert-at-cursor ()
  (interactive)
  (if meow--temp-normal (progn (message "Quit temporary normal mode")
                               (meow--switch-state 'motion))
    (meow--cancel-selection)
    (if meow-beacon-mode (meow-beacon-insert)
      (meow-insert))))

(defun meow-delete-selection-hook ()
  "Restore default behavior of text entry replacing the selected
region in insert mode, and of `delete-backward-char' everywhere."
  (add-hook 'meow-insert-enter-hook 'enable-delete-selection-mode nil t)
  (add-hook 'meow-insert-exit-hook 'disable-delete-selection-mode nil t))

(add-hook 'meow-mode-hook 'meow-delete-selection-hook)

(add-to-list 'meow-mode-state-list '(eat-mode . insert))

(meow-motion-overwrite-define-key
 '("i" . meow-prev)
 '("j" . "H-j")
 '("k" . meow-next)
 '("<escape>" . ignore))

(meow-leader-define-key
 ;; SPC i/k will run the original command in MOTION state
 '("i" . "H-i")
 '("k" . "H-k")
 ;; Use SPC (0-9) for digit arguments.
 '("1" . meow-digit-argument)
 '("2" . meow-digit-argument)
 '("3" . meow-digit-argument)
 '("4" . meow-digit-argument)
 '("5" . meow-digit-argument)
 '("6" . meow-digit-argument)
 '("7" . meow-digit-argument)
 '("8" . meow-digit-argument)
 '("9" . meow-digit-argument)
 '("0" . meow-digit-argument)
 '("/" . meow-keypad-describe-key)
 '("?" . meow-cheatsheet))

(meow-normal-define-key
 ;; movement
 '("i" . meow-prev)
 '("j" . meow-left)
 '("k" . meow-next)
 '("l" . meow-right)
 '("'" . meow-pop-to-mark)
 '("\"" . meow-unpop-to-mark)

 ;; selection
 '("A" . meow-goto-line)
 '("g" . meow-cancel-selection)
 '("G" . meow-grab)
 '("x" . meow-join)
 '("z" . meow-pop-selection)
 '(";" . meow-reverse)

 ;; by character
 '("I" . meow-prev-expand)
 '("J" . meow-left-expand)
 '("K" . meow-next-expand)
 '("L" . meow-right-expand)
 '("t" . meow-till)
 '("T" . meow-find)

 ;; by thing
 '("b" . meow-beginning-of-thing)
 '("B" . meow-bounds-of-thing)
 '("n" . meow-end-of-thing)
 '("N" . meow-inner-of-thing)

 ;; by word/symbol
 '("F" . meow-visit)
 '("o" . meow-next-word)
 '("O" . meow-next-symbol)
 '("u" . meow-back-word)
 '("U" . meow-back-symbol)
 '("w" . meow-mark-word)
 '("W" . meow-mark-symbol)

 ;; with inertia
 '("1" . meow-expand-1)
 '("2" . meow-expand-2)
 '("3" . meow-expand-3)
 '("4" . meow-expand-4)
 '("5" . meow-expand-5)
 '("6" . meow-expand-6)
 '("7" . meow-expand-7)
 '("8" . meow-expand-8)
 '("9" . meow-expand-9)
 '("0" . meow-expand-0)
 '("a" . meow-line)
 '("e" . meow-block)
 '("E" . meow-to-block)
 '("f" . meow-search)

 ;; insertion
 '("m" . meow-insert-at-cursor)
 '("," . meow-open-above)
 '("." . meow-open-below)

 ;; modification
 '("d" . meow-delete)
 '("D" . meow-backward-delete)
 '("h" . meow-undo)
 '("H" . meow-undo-in-selection)
 '("p" . meow-save)
 '("r" . meow-replace)
 '("R" . query-replace-regexp)
 '("s" . meow-kill)
 '("S" . meow-change)
 '("y" . meow-yank)

 '("-" . negative-argument)
 '("<escape>" . ignore))
