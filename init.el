;;; package --- Summary

;;; Commentary:
;;; This file runs when you first open Emacs.

;;; Code:
(setq gc-cons-threshold (* 50 1024 1024))

(package-initialize)
(setq package-enable-at-startup nil)


(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)


(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)


(use-package evil :config (evil-mode 1))


(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq gc-cons-threshold (* 2 1024 1024))
	    (message "Emacs ready in %s with %d garbage collections."
		     (format "%.2f seconds"
			     (float-time
			      (time-subtract after-init-time before-init-time)))
		     gcs-done)))


(menu-bar-mode -1)
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))


(setq inhibit-splash-screen t)
(switch-to-buffer "**")


(setq make-backup-files nil)
(setq auto-save-default nil)


(defalias 'yes-or-no-p 'y-or-n-p)


(setq ring-bell-function 'ignore)


(use-package atom-one-dark-theme)


(use-package linum-relative
  :config (linum-relative-global-mode)
  :custom (linum-relative-current-symbol ""))


(use-package company
  :hook (prog-mode . company-mode)
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 1))


(use-package which-key
  :defer 1
  :config (which-key-mode))


(use-package flycheck
  :hook (prog-mode . flycheck-mode))


(use-package flymake
  :hook python-mode)


(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)
  :custom (show-paren-delay 0)
  :config (show-paren-mode 1))


(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :commands sp-local-pair
  :config
  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
  (sp-local-pair 'emacs-lisp-mode "`" nil :actions nil))


(use-package evil-smartparens
  :hook (smartparens . evil-cleverparens-mode))


(use-package evil-cleverparens
  :hook (emacs-lisp-mode . evil-cleverparens-mode))


(use-package aggressive-indent
  :hook (emacs-lisp-mode . aggressive-indent-mode))


(use-package adjust-parens
  :hook (emacs-lisp-mode . adjust-parens-mode)
  :bind (("TAB" . lisp-indent-adjust-parens)
	 ("<backtab>" . lisp-dedent-adjust-parens)))


(use-package elpy
  :hook python-mode

  :config
  (elpy-enable)
  (add-to-list 'python-shell-completion-native-disabled-interpreters
	       "jupyter")
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py\\'" flymake-mypy-init))

  :custom
  (python-shell-interpreter "jupyter")
  (python-shell-interpreter-args "console --simple-prompt")
  (python-shell-prompt-detect-failure-warning nil))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (elpy adjust-parens aggressive-indent evil-cleverparens evil-smartparens smartparens rainbow-delimiters flycheck which-key company linum-relative atom-one-dark-theme evil use-package))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
