;;; init.el --- Emacs configuration for a data scientist

;; Ensure package system is initialized
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ESS (Emacs Speaks Statistics) for R
(use-package ess
  :ensure t
  :config
  (setq ess-ask-for-ess-directory nil)
  (setq ess-use-flymake t)
  (setq ess-flymake-show-process-buffer nil)
  (setq ess-flymake-max-time 10)
  (setq ess-flymake-message-timeout 10)
  (setq ess-r-flymake-lintr-executable "lintr::lintr")
  (setq ess-r-flymake-lintr-args '("--language_style=tidyverse")))

;; Python support
(use-package python
  :ensure t
  :config
  (setq python-shell-interpreter "python3"
        python-shell-interpreter-args "-i"))

;; SQLite support
(use-package sqlite-mode
  :ensure t)

;; Org mode
(use-package org
  :ensure t
  :config
  (setq org-babel-load-languages
        '((emacs-lisp . t)
          (R . t)
          (python . t)
          (shell . t)
          (sqlite . t)))
  (setq org-src-fontify-natively t)
  (setq org-confirm-babel-evaluate nil)
  (setq org-babel-default-header-args:R
        '((:session . "*R*")
          (:results . "output")
          (:exports . "both")))
  (setq org-babel-default-header-args:python
        '((:session . "python")
          (:results . "output")
          (:exports . "both"))))

;; RMarkdown support
(use-package poly-R
  :ensure t
  :config
  (require 'poly-R)
  (require 'poly-markdown)
  (add-to-list 'auto-mode-alist '("\\.Rmd\\'" . poly-markdown+r-mode)))

;; Helm
(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x b") 'helm-buffers-list))

;; Smartparens
(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode 1))

;; Other useful packages
(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "C-x g") 'magit-status))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

(use-package company
  :ensure t
  :config
  (global-company-mode))

;; Customizations
(setq inhibit-startup-message t)
(setq confirm-kill-emacs 'yes-or-no-p)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq show-trailing-whitespace t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default fill-column 80)

;; Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))

(setq ring-bell-function 'ignore)

;; Provide
(provide 'init)


(require 'org)

;; Enable R source block execution in Org-Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)))

(setq shell-file-name "/bin/bash")
