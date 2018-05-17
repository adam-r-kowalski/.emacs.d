;;; package --- Summary

;;; Commentary:
;;; This file runs when Emacs first launches

;;; Code:
(set-face-attribute 'default nil :height 160)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-screen t)
(setq initial-scratch-message "")

(setq make-backup-files nil)

(setq ring-bell-function 'ignore)

(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)

(use-package evil :defer t :init (evil-mode 1))

(use-package diminish :defer t)

(use-package undo-tree
  :defer t
  :diminish undo-tree-mode)

(use-package linum-relative
  :defer t
  :init
  (linum-relative-global-mode)
  (setq linum-relative-current-symbol "")
  :diminish linum-relative-mode)

(use-package exec-path-from-shell
  :defer t
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package zerodark-theme
  :defer t
  :init
  (load-theme 'zerodark t)
  (zerodark-setup-modeline-format))

(use-package ivy
  :defer t
  :init
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
	enable-recursive-minibuffers t)
  :diminish ivy-mode)

(use-package counsel :defer t)
(use-package counsel-projectile :defer t)

(use-package which-key
  :defer t
  :init (which-key-mode)
  :diminish which-key-mode)

(use-package general :defer t)

(general-define-key
 :states 'normal
 :keymaps '(global dired-mode-map)
 :prefix "SPC"
 "g" 'magit
 "f" 'counsel-find-file
 "F" 'counsel-projectile
 "r" 'counsel-recentf
 "x" 'counsel-M-x
 "S" 'counsel-projectile-ag
 "l" 'swiper
 "w" '(nil :which-key "window")
 "b" '(nil :which-key "buffer")
 "s" 'shell)

(general-define-key
 :states 'normal
 :keymaps '(global dired-mode-map)
 :prefix "SPC w"
 "/" 'split-window-horizontally
 "-" 'split-window-vertically
 "m" 'delete-other-windows
 "h" 'evil-window-left
 "j" 'evil-window-down
 "k" 'evil-window-up
 "l" 'evil-window-right)

(defun kill-other-buffers ()
      "Kill all other buffers."
      (interactive)
      (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(general-define-key
 :states 'normal
 :keymaps '(global dired-mode-map)
 :prefix "SPC b"
 "s" 'ivy-switch-buffer
 "l" 'list-buffers
 "o" 'kill-other-buffers
 "k" 'kill-buffer-and-window)

(general-define-key
 :keymaps 'emacs-lisp-mode-map
 :states 'normal
 :prefix ","
 "e" 'eval-defun)

(general-define-key
 :keymaps 'c++-mode-map
 :states 'normal
 :prefix ","
 "e" 'compile)

(use-package company
  :defer t
  :init
  (global-company-mode)
  (setq company-idle-delay 0
	company-minimum-prefix 2
	company-tooltip-limit 20)
  :diminish company-mode)

(defun my-c++-mode-before-save-hook ()
  "Whenever you save a c++ file run clang format first."
  (when (eq major-mode 'c++-mode)
    (clang-format-buffer)))

(use-package clang-format
  :defer t
  :init (add-hook 'before-save-hook #'my-c++-mode-before-save-hook))

(use-package irony
  :defer t
  :init
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  :diminish irony-mode)

(use-package company-irony
  :defer t
  :init
  (eval-after-load 'company
    '(add-to-list 'company-backends 'company-irony)))

(use-package irony-eldoc
  :defer t
  :init (add-hook 'irony-mode-hook #'irony-eldoc)
  :diminish eldoc-mode)

(use-package flycheck
  :defer t
  :init (global-flycheck-mode)
  :diminish flycheck-mode)

(use-package flycheck-irony
  :defer t
  :init
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup)))

(use-package cmake-mode :defer t)

(add-to-list 'auto-mode-alist '("\\.tpp\\'" . c++-mode))

(use-package intero
  :defer t
  :init (add-hook 'haskell-mode-hook 'intero-mode))

(general-define-key
 :keymaps 'haskell-mode-map
 :states 'normal
 :prefix ","
 "e" 'intero-repl-load)

(general-define-key
 :keymaps 'intero-repl-mode-map
 :states 'normal
 :prefix ","
 "c" 'intero-repl-clear-buffer)

(use-package flyspell
  :defer t
  :init
  (add-hook 'text-mode-hook (lambda () (flyspell-mode 1)))
  (add-hook 'prog-mode-hook (lambda () (flyspell-prog-mode)))
  :diminish flyspell-mode)

(use-package rainbow-delimiters
  :defer t
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  (show-paren-mode 1)
  (setq show-paren-delay 0))

(use-package evil-cleverparens
  :defer t
  :init
  (add-hook 'emacs-lisp-mode-hook #'evil-cleverparens-mode)
  (add-hook 'clojure-mode-hook #'evil-cleverparens-mode)
  (add-hook 'cider-repl-mode-hook #'evil-cleverparens-mode)
  :diminish evil-cleverparens-mode)

(use-package adjust-parens :ensure t)


(use-package aggressive-indent
  :defer t
  :init
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode)
  (add-hook 'cider-repl-mode-hook #'aggressive-indent-mode))

(use-package smartparens
  :defer t
  :init
  (add-hook 'prog-mode-hook #'smartparens-mode)
  (add-hook 'smartparens-mode-hook
	    #'(lambda ()
		(sp-pair "'" nil :actions :rem)
		(sp-pair "`" nil :actions :rem)))
  :diminish smartparens-mode)

(use-package evil-smartparens
  :defer t
  :init
  (add-hook 'smartparens-mode-hook #'evil-smartparens-mode)
  :diminish evil-smartparens-mode)

(use-package clojure-mode :defer t)

(use-package clojure-mode-extra-font-locking :defer t)

(use-package cider :defer t)

(general-define-key
 :states 'normal
 :keymaps 'clojure-mode-map
 :prefix ","
 "r" '(nil :which-key "repl")
 "e" 'cider-eval-defun-at-point
 "b" 'cider-eval-buffer
 "c" 'cider-refresh
 "d" 'cider-debug-defun-at-point
 "w" 'cider-eval-last-sexp-and-replace
 "h" 'cider-doc)

(general-define-key
 :states 'normal
 :keymaps 'clojure-mode-map
 :prefix ",r"
 "j" 'cider-jack-in
 "c" 'cider-connect)

(general-define-key
 :states 'normal
 :keymaps 'clojurescript-mode-map
 :prefix ",r"
 "j" 'cider-jack-in-clojurescript
 "c" 'cider-connect)

(general-define-key
 :states 'normal
 :keymaps 'cider-repl-mode-map
 :prefix ","
 "t" 'cider-repl-set-type
 "c" 'cider-repl-clear-buffer)

(general-define-key
 :states '(normal insert)
 :keymaps '(emacs-lisp-mode-map clojure-mode-map)
 "TAB" 'lisp-indent-adjust-parens
 "<backtab>" 'lisp-dedent-adjust-parens)

(defun setup-tide-mode ()
  "Code to run when typescript mode is enabled."
  (interactive)
  (tide-setup)
  (tide-hl-identifier-mode 1))

(use-package tide
  :defer t
  :init
  (add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook #'setup-tide-mode))


(use-package web-mode
  :defer t
  :init
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-hook 'web-mode-hook
	    (lambda ()
	      (when (string-equal "tsx"
				  (file-name-extension buffer-file-name))
		(setup-tide-mode))))
  (flycheck-add-mode 'typescript-tslint 'web-mode))

(use-package ensime
  :defer t
  :init (setq ensime-eldoc-hints 'all
	      ensime-search-interface 'ivy))

(use-package sbt-mode :defer t)

(use-package scala-mode :defer t)

(general-define-key
 :states 'normal
 :keymaps 'scala-mode-map
 :prefix ","
 "e" 'ensime
 "f" '(nil :which-key "find")
 "i" '(nil :which-key "interactive")
 "s" '(nil :which-key "search")
 "r" '(nil :which-key "refactor")
 "d" '(nil :which-key "debug")
 "h" '(nil :which-key "documentation"))

(general-define-key
 :states 'normal
 :keymaps 'scala-mode-map
 :prefix ",f"
 "u" 'sbt-find-usages
 "d" 'sbt-find-definitions)

(general-define-key
 :states '(normal visual)
 :keymaps 'scala-mode-map
 :prefix ",i"
 "s" 'ensime-inf-switch
 "d" 'ensime-inf-eval-definition
 "b" 'ensime-inf-eval-buffer
 "r" 'ensime-inf-eval-region)

(general-define-key
 :states 'normal
 :keymaps 'scala-mode-map
 :prefix ",s"
 "s" 'ensime-search
 "c" 'ensime-search-classic
 "i" 'ensime-search-ivy
 "d" 'ensime-search-sym-decl-as
 "l" 'ensime-search-sym-local-name
 "n" 'ensime-search-sym-name
 "o" 'ensime-search-sym-owner-name
 "p" 'ensime-search-sym-pos)

(general-define-key
 :states 'normal
 :keymaps 'scala-mode-map
 :prefix ",d"
 "b" 'ensime-db-set-break
 "r" 'ensime-db-clear-break
 "c" 'ensime-db-continue
 "s" 'ensime-db-step
 "o" 'ensime-db-step-out
 "i" 'ensime-db-inspect-value-at-point
 "t" 'ensime-db-backtrace
 "a" 'ensime-db-attach)

(general-define-key
 :states 'normal
 :keymaps 'scala-mode-map
 :prefix ",r"
 "t" 'ensime-refactor-add-type-annotation
 "r" 'ensime-refactor-diff-rename
 "o" 'ensime-refactor-diff-organize-imports
 "m" 'ensime-refactor-diff-extract-method
 "l" 'ensime-refactor-diff-extract-local
 "i" 'ensime-refactor-diff-inline-local)

(general-define-key
 :states 'normal
 :keymaps 'scala-mode-map
 :prefix ",h"
 "s" 'ensime-show-doc-for-symbol-at-point
 "p" 'ensime-project-docs)

(use-package rust-mode
  :defer t
  :init (setq rust-format-on-save t))

(use-package flycheck-rust
  :defer t
  :init (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package racer
  :defer t
  :init
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode))

(general-define-key
 :states 'normal
 :keymaps 'rust-mode-map
 :prefix ","
 "e" 'compile)

(use-package toml-mode :defer t)

(use-package magit :defer t
  :init
  (add-hook 'magit #'evil-magit-init)
  (add-hook 'magit #'evil-mode)
  (add-hook 'magit #'turn-on-evil-mode))

(use-package evil-magit :defer t
  :init (setq evil-magit-state 'normal))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (evil-magit toml-mode racer flycheck-rust rust-mode ensime web-mode tide tid counsel-projectile counsel psc-ide adjust-parens abbrev zerodark-theme fancy-battery spaceline-config spacemacs-theme spaceline clojure-mode-extra-font-locking evil-smartparens aggressive-indent diminish evil-cleverparens rainbow-delimiters intero cmake-mode flycheck-irony irony-eldoc company-irony irony clang-format company general which-key ivy doom-themes exec-path-from-shell linum-relative evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
