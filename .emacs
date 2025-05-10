;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(context-menu-mode t)
 '(cursor-type 'bar)
 '(custom-enabled-themes '(modus-operandi-tinted))
 '(dired-listing-switches "-ahl")
 '(display-time-mode t)
 '(eat-kill-buffer-on-exit t)
 '(eat-term-name "xterm-256color")
 '(eat-tramp-shells '(("docker" . "/bin/sh") ("ssh" . "/bin/bash")))
 '(global-whitespace-mode t)
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(line-number-mode t)
 '(magit-diff-refine-hunk t)
 '(magit-process-connection-type nil)
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

(eval-after-load "dired"
  '(progn (define-key dired-mode-map [mouse-2] 'dired-mouse-find-file)))

(setq exec-path
      (if (member "/opt/homebrew/bin" exec-path)
          exec-path
        (append (list "/opt/homebrew/bin") exec-path)))

(when (not (member "~/.emacs.d/emacs-eat" load-path))
  (push "~/.emacs.d/emacs-eat" load-path)
  (require 'eat))

(defun js-date (region-start region-end)
  "Mostly equivalent to JavaScript's `new Date(value)', assuming
the text content of the selected REGION consists of a single VALUE
representing the number of milliseconds since the Unix epoch."
  (interactive "r")
  (let* ((timestamp (string-to-number
                     (buffer-substring-no-properties region-start region-end)))
         (time (/ timestamp 1000)))
    (message (format-time-string "%a %b %d %Y %T %z (%Z)" time))))

(defun meow-insert-at-cursor ()
  (interactive)
  (if meow--temp-normal
      (progn
        (message "Quit temporary normal mode")
        (meow--switch-state 'motion))
    (meow--cancel-selection)
    (meow--switch-state 'insert)))

(defun meow-setup ()
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (setq meow-mode-state-list
        (if (member '(eat-mode . insert) meow-mode-state-list)
            meow-mode-state-list
          (append (list '(eat-mode . insert)) meow-mode-state-list)))
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
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
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-join)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert-at-cursor)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . ignore)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))

(require 'meow)
(meow-setup)
(meow-global-mode 1)
