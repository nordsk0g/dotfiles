;;; init.el --- Steven's init file: -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

;; Packages

(require 'package)
(require 'use-package)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")
	("melpa" . "https://melpa.org/packages/")))

;; General styling

(setq-default inhibit-splash-screen t
	      visible-bell 1
	      display-line-numbers-type 'relative
	      column-number-mode t)

(add-hook 'font-lock-mode-hook (lambda () (setq-default show-trailing-whitespace t)))

(tool-bar-mode -1)
(menu-bar-mode -1)

'(global-display-line-numbers-mode t)
'(column-number-mode t)

;; auto-saving
(setq auto-save-default nil)
(setq auto-save-interval 20)
(setq auto-save-visited-mode 1)
(setq auto-save-visited-interval 1)

(setq make-backup-files nil)
(setq create-lockfiles nil)

;; Theme
(use-package modus-themes
  :ensure t
  :demand t)

(use-package ef-themes
  :ensure t
  :demand t)

;; Add all your customizations prior to loading the themes
(setq modus-themes-italic-constructs t
      modus-themes-bold-constructs nil)

;; Load the theme of your choice.
(load-theme 'modus-vivendi :no-confirm)

(define-key global-map (kbd "<f5>") #'modus-themes-toggle)
(setq default-frame-alist '((font . "Aporetic Sans Mono 14")))

;; Quality of life
(global-set-key [remap list-buffers] 'ibuffer)
(global-set-key (kbd "C-,") 'duplicate-line)

;; Window management
(global-set-key (kbd "M-o") 'other-window)
(windmove-default-keybindings)

;; Elemental movement
'(global-subword-mode t)
'(global-superword-mode t)

;; rainbow-mode
(use-package rainbow-mode)

;; buffer completion
(use-package vertico
  :ensure t
  :config
  (setq vertico-cycle t)
  (setq vertico-resize nil)
  (vertico-mode 1))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

(use-package orderless
  :ensure t
  )

(use-package consult
  :bind (
	 ("C-x b" . consult-buffer)
	 ("M-g o" . consult-outline)
	 ("M-s g" . consult-grep)
	 ("M-s r" . consult-ripgrep)
	 ("M-s l" . consult-line)
	 ("M-s L" . consult-line-multi)
	 )

  :init

  :config

  (setq consult-preview-key nil)
  (setq consult-narrow-key "<"))

;; Magit
(use-package magit)

;; Org mode
(use-package org)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(setq org-agenda-files (list "~/org/work.org"
			     "~/org/personal.org"))

;; Org-roam
(use-package org-roam
  :custom
  (org-roam-directory "~/org-roam")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
	 ("C-c n I" . org-roam-node-insert-immediate)
	 :map org-mode-map
	 ("C-M-i"   . completion-at-point)))

(use-package annotate)

;; Org-roam immediate insert
(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
	(org-roam-capture-templates (list (append (car org-roam-capture-templates)
						  '(:immediate-finish t)))))
  (apply #'org-roam-node-insert args)))

; Programming

;; clang-format

(use-package clang-format
  :init
  (setq clang-format-fallback-style "gnu"))
(setq-default c-ts-mode-indent-style 'gnu)

;; Sly
(use-package sly
  :init
  (setq inferior-lisp-program "/usr/sbin/sbcl"))

;; Treesitter
(setq treesit-language-source-alist
      '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
        (c . ("https://github.com/tree-sitter/tree-sitter-c"))
        (c++ . ("https://github.com/tree-sitter/tree-sitter-cpp"))
        (c-sharp
	 . ("https://github.com/tree-sitter/tree-sitter-c-sharp"))
	(commonlisp
	 . ("https://github.com/tree-sitter-grammars/tree-sitter-commonlisp"))
	(bash
	 . ("https://github.com/tree-sitter/tree-sitter-bash"))
	(elisp
	 . ("https://github.com/tree-sitter/tree-sitter-elisp"))))

(setq major-mode-remap-alist
      '((c-mode . c-ts-mode)
	(c++-mode . c++-ts-mode)
	(csharp-mode . csharp-ts-mode)
	(bash-mode . bash-ts-mode)
	))

(use-package eglot)

(add-to-list 'eglot-server-programs
	     '((c-ts-mode c++-ts-mode) "clangd"))
(add-to-list 'eglot-server-programs
	     '(csharp-ts-mode . ("/opt/omnisharp/OmniSharp" "-lsp")))

(add-hook 'c-ts-mode-hook 'eglot-ensure)
(add-hook 'c++-ts-mode-hook 'eglot-ensure)
(add-hook 'csharp-ts-mode-hook 'eglot-ensure)

;; Compile hooks
(add-hook 'c-ts-mode-hook
	  (lambda ()
	    (setq-local compile-command
			(format "gcc -Og -o \"%s\" %s"
			(file-name-sans-extension buffer-file-name)
			(file-name-nondirectory buffer-file-name)))))
(add-hook 'c++-ts-mode-hook
	  (lambda ()
	    (setq-local compile-command
			(format "g++ -std=c++23 -fmodules-ts %s -o %s"
			(file-name-sans-extension buffer-file-name)
			(file-name-nondirectory buffer-file-name)))))

(add-hook 'csharp-ts-mode-hook
	  (lambda ()
	    (setq-local compile-command
			(format "dotnet run"))))

(use-package company
  :ensure
  :custom
  (company-idle-delay 0.5)
  :bind
  (:map company-active-map
	("C-n" . company-select-next)
	("C-p" . company-select-previous)
	("M-<" . company-select-first)
	("M->" . company-select-last)))

;; Which-Key
(use-package which-key
  :config
  (which-key-mode))

;; Projectile
(use-package projectile
  :ensure t
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (projectile-mode +1))

;; Flycheck
(use-package flycheck :ensure)
(global-flycheck-mode)

;; AUCTeX
(use-package auctex
  :ensure t
  :defer t
  :hook (LaTeX-mode . (lambda ()
			(push (list 'output-pdf "Okular")
			      TeX-view-program-selection))))
(setq-default TeX-auto-save t)
(setq-default TeX-parse-self t)
(setq-default TeX-master nil)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.8))

(use-package gptel)
(gptel-make-openai-oauth "OpenAI-sub")

(setq custom-file "~/.emacs.d/custom.el")

(provide 'init)
;;; init.el ends here
