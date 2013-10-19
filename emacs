; My emacs config.  Much stolen shamelessly from Aaron Bedra (http://www.aaronbedra.com/emacs.d/)
(require 'cl)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (vibrant-ink)))
 '(custom-safe-themes (quote ("fd7cc40cf268dbe989c2f7c884cf15cc192d659d78088f0489999ffa597859f4" "f9ea2149d210a21bf9c2b017854adc60e790b83b27284bd3a8a23b1a257673d7" "76a00c271f7004a7c8e9412e11bcd72dcf996fcfe5db3d4be648016e500cebce" "a6d39b3e27d45aea4bf0c20a9f6ccbff858eae1728ac0cf72d6a86bd873202d2" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(when (display-graphic-p)
    (set-background-color "black"))

(setq user-full-name "Stephen Gelman")
(setq user-mail-address "ssgelm@gmail.com")

(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq package-archive-enable-alist '(("melpa" deft magit)))

(defvar sg/packages '(ac-slime
                      auto-complete
                      autopair
                      clojure-mode
                      clojure-test-mode
                      coffee-mode
                      deft
                      gist
                      go-mode
                      haml-mode
                      haskell-mode
                      htmlize
                      magit
                      markdown-mode
                      marmalade
                      nrepl
                      o-blog
                      org
                      paredit
                      puppet-mode
                      restclient
                      rvm
                      smex
                      sml-mode
                      yaml-mode)
  "Default packages")

(defun sg/packages-installed-p ()
  (loop for pkg in sg/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (sg/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg sg/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

(setq inhibit-splash-screen t
      initial-scratch-message nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

(setq tab-width 2
      indent-tabs-mode nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(show-paren-mode t)
(setq visible-bell t)

(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(ido-mode t)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)

(setq column-number-mode t)

(require 'autopair)

(setq lisp-modes '(lisp-mode
                   emacs-lisp-mode
                   common-lisp-mode
                   scheme-mode
                   clojure-mode))

(defvar lisp-power-map (make-keymap))
(define-minor-mode lisp-power-mode "Fix keybindings; add power."
  :lighter " (power)"
  :keymap lisp-power-map
  (paredit-mode t))
(define-key lisp-power-map [delete] 'paredit-forward-delete)
(define-key lisp-power-map [backspace] 'paredit-backward-delete)

(defun sg/engage-lisp-power ()
  (lisp-power-mode t))

(dolist (mode lisp-modes)
  (add-hook (intern (format "%s-hook" mode))
            #'sg/engage-lisp-power))

(setq inferior-lisp-program "clisp")
(setq scheme-program-name "racket")

(require 'auto-complete-config)
(ac-config-default)

(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun cleanup-region (beg end)
  "Remove tmux artifacts from region."
  (interactive "r")
  (dolist (re '("\\\\│\·*\n" "\W*│\·*"))
    (replace-regexp re "" nil beg end)))

(global-set-key (kbd "C-x M-t") 'cleanup-region)
(global-set-key (kbd "C-c n") 'cleanup-buffer)

(add-hook 'ruby-mode-hook
          (lambda ()
            (autopair-mode)))

(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile" . ruby-mode))

(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
