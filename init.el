;;; package --- Summary

;;; Commentary:
;;; This file runs when Emacs first launches

;;; Code:
(set-face-attribute 'default nil :height 160)

(menu-bar-mode -1)
(tooltip-mode -1)

(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

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

(use-package company
  :defer t
  :init
  (global-company-mode)
  (setq company-idle-delay 0
	company-minimum-prefix 0
	company-tooltip-limit 20)
  :diminish company-mode)

(use-package flycheck
  :defer t
  :init (global-flycheck-mode)
  :diminish flycheck-mode)

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
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
  (show-paren-mode 1)
  (setq show-paren-delay 0))

(use-package evil-cleverparens
  :defer t
  :init
  (add-hook 'emacs-lisp-mode-hook #'evil-cleverparens-mode)
  :diminish evil-cleverparens-mode)

(use-package adjust-parens :ensure t)


(use-package aggressive-indent
  :defer t
  :init
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode))


(use-package smartparens
  :defer t
  :init
  (add-hook 'prog-mode-hook #'smartparens-mode)
  (add-hook 'smartparens-mode-hook
	    #'(lambda ()
		(sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
		(sp-local-pair 'emacs-lisp-mode "`" nil :actions nil)))
  :diminish smartparens-mode)

(use-package evil-smartparens
  :defer t
  :init
  (add-hook 'smartparens-mode-hook #'evil-smartparens-mode)
  :diminish evil-smartparens-mode)

(use-package magit :defer t
  :init
  (add-hook 'magit #'evil-magit-init)
  (add-hook 'magit #'evil-mode)
  (add-hook 'magit #'turn-on-evil-mode))

(use-package evil-magit :defer t
  :init (setq evil-magit-state 'normal))


(general-define-key
 :states '(normal insert)
 :keymaps 'emacs-lisp-mode-map
 "TAB" 'lisp-indent-adjust-parens
 "<backtab>" 'lisp-dedent-adjust-parens)


(defun python-save-hook ()
  "Hook to run when saving a file in python mode."
  (when (eq major-mode 'python-mode)
    (elpy-yapf-fix-code)))


(defun flymake-mypy-init ()
  "Init mypy."
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "mypy" (list local-file "-s"))))


(use-package elpy
  :defer t
  :init
  (elpy-enable)
  (setq python-shell-interpreter "jupyter"
	python-shell-interpreter-args "console --simple-prompt"
	python-shell-prompt-detect-failure-warning nil)
  (add-to-list 'python-shell-completion-native-disabled-interpreters
	       "jupyter")
  (add-hook 'before-save-hook #'python-save-hook)
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py\\'" flymake-mypy-init)))


(general-define-key
 :states '(normal visual)
 :keymaps 'python-mode-map
 :prefix ","
 "a" 'elpy-goto-assignment
 "A" 'elpy-goto-assignment-other-window
 "d" 'elpy-goto-definition
 "D" 'elpy-goto-definition-other-window
 "s" 'elpy-shell-switch-to-shell
 "S" 'elpy-shell-switch-to-shell-in-current-window
 "k" 'elpy-shell-kill
 "K" 'elpy-shell-kill-all
 "e" 'elpy-shell-send-statement
 "E" 'elpy-shell-send-statement-and-step
 "g" 'elpy-shell-send-group
 "G" 'elpy-shell-send-group-and-step
 "v" 'elpy-shell-send-region-or-buffer
 "V" 'elpy-shell-send-region-or-buffer-and-step
 "t" 'elpy-shell-send-top-statement
 "T" 'elpy-shell-send-top-statement-and-step
 "f" 'elpy-shell-send-defun
 "F" 'elpy-shell-send-defun-and-step
 "b" 'elpy-shell-send-buffer
 "B" 'elpy-shell-send-buffer-and-step
 "c" 'elpy-shell-send-defclass
 "C" 'elpy-shell-send-defclass-and-step
 "n" 'elpy-flymake-next-error
 "N" 'elpy-flymake-previous-error
 "h" 'elpy-doc
 "u" 'elpy-test
 "r" '(nil :which-key "refactor")
 "p" 'elpy-profile-buffer-or-region)

(general-define-key
 :states '(normal visual)
 :keymaps 'python-mode-map
 :prefix ",r"
 "s" 'elpy-multiedit-python-symbol-at-point
 "f" 'elpy-format-code
 "r" 'elpy-refactor)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (flycheck-mypy flymake-mypy elpy evil-magit evil-smartparens aggressive-indent adjust-parens evil-cleverparens rainbow-delimiters company general which-key counsel-projectile counsel ivy zerodark-theme exec-path-from-shell linum-relative diminish evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
