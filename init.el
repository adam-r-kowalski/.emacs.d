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


(eval-when-compile
  (require 'use-package))
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
  :defer 1
  :config (global-company-mode)
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 1))


(use-package which-key
  :defer 1
  :config (which-key-mode))


(use-package flycheck
  :defer 1
  :config (global-flycheck-mode))


(provide 'init)
;;; init.el ends here
