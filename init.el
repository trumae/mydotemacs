(load (expand-file-name "~/quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl")

(require 'package)
(add-to-list 'package-archives
             '("MELPA Stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

(use-package markdown-mode)
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  )
(use-package go-eldoc)
(use-package go-errcheck)
(use-package go-mode)
;; ;(autoload 'go-mode "go-mode" nil t)
;; ;(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(use-package magit)
(use-package beacon
  :ensure t
  :init (beacon-mode 1))
(use-package lsp-mode)
(use-package lua-mode)
(use-package org)
(use-package org-trello)
(use-package ack)
(use-package google-translate)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-trello-current-prefix-keybinding "C-c o" nil (org-trello))
 '(package-selected-packages
   '(go-errcheck go-eldoc tuareg slime projectile haskell-mode flx-ido use-package markdown-mode go-mode flycheck)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
