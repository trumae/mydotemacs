(setq user-mail-address "trumae@gmail.com")
(setq user-full-name "Trumae da Ilha")

;; descomente para habilitar
;(load (expand-file-name "~/quicklisp/slime-helper.el"))
;(setq inferior-lisp-program "sbcl")
;(setq inferior-lisp-program "ecl")
;(setq inferior-lisp-program "/home/trumae/projs/ccl/lx86cl64")

(menu-bar-mode 0)
(column-number-mode 1)
(global-hl-line-mode 0)
(show-paren-mode 1)

(require 'package)
(add-to-list 'package-archives	     
             '("MELPA Stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives	     
             '("GNU" . "http://elpa.gnu.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

(require 'use-package)

;;;;;;;;;;;;;;;; C/C++ ;;;;;;;;;;;;;;;
(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(global-semantic-stickyfunc-mode 1)

(semantic-mode 1)

(defun alexott/cedet-hook ()
  (local-set-key "\C-c\C-j" 'semantic-ia-fast-jump)
  (local-set-key "\C-c\C-s" 'semantic-ia-show-summary))

(add-hook 'c-mode-common-hook 'alexott/cedet-hook)
(add-hook 'c-mode-hook 'alexott/cedet-hook)
(add-hook 'c++-mode-hook 'alexott/cedet-hook)

;; Enable EDE only in C/C++
(require 'ede)
(global-ede-mode)

;; Setup irony
(use-package irony)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; Setup company-mode
(require 'company)
(require 'irony)

(use-package company-irony-c-headers
  :config
  (add-to-list
   'company-backends '(company-irony-c-headers company-irony)))
(add-hook 'after-init-hook 'global-company-mode)

;; install gnu global: `apt-get install global`
(use-package ggtags
  :init
  (add-hook 'c-mode-common-hook
            (lambda ()
              (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
		(ggtags-mode 1)))))
(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)
(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)


(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package markdown-mode)
(use-package rustic)
(use-package yasnippet
  :ensure t)
(use-package flycheck)
(use-package projectile)
(use-package go-eldoc)
(use-package go-errcheck)
(use-package go-mode)

(add-to-list 'exec-path "~/go/bin")
(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'go-mode-hook #'lsp)
		   
;; Bonus: escape analysis.
(flycheck-define-checker go-build-escape
  "A Go escape checker using `go build -gcflags -m'."
  :command ("go" "build" "-gcflags" "-m"
            (option-flag "-i" flycheck-go-build-install-deps)
            ;; multiple tags are listed as "dev debug ..."
            (option-list "-tags=" flycheck-go-build-tags concat)
            "-o" null-device)
  :error-patterns
  (
   (warning line-start (file-name) ":" line ":"
            (optional column ":") " "
            (message (one-or-more not-newline) "escapes to heap")
            line-end)
   (warning line-start (file-name) ":" line ":"
            (optional column ":") " "
            (message "moved to heap:" (one-or-more not-newline))
            line-end)
   (info line-start (file-name) ":" line ":"
         (optional column ":") " "
         (message "inlining call to " (one-or-more not-newline))
         line-end)
   )
  :modes go-mode
  :predicate (lambda ()
               (and (flycheck-buffer-saved-p)
                    (not (string-suffix-p "_test.go" (buffer-file-name)))))
  :next-checkers ((warning . go-errcheck)
                  (warning . go-unconvert)
                  (warning . go-staticcheck)))

(with-eval-after-load 'flycheck
  (add-to-list 'flycheck-checkers 'go-build-escape)
  (flycheck-add-next-checker 'go-gofmt 'go-build-escape))


(use-package magit)
(setq magit-fetch-modules-jobs 16)

(use-package beacon
  :ensure t
  :init (beacon-mode 1))
(use-package lua-mode)
(use-package org)
(require 'ob-tangle)
;(use-package org-trello)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((gnuplot . t)
   (lisp . t)
   (lua . t)
   (emacs-lisp . t)
   (js . t)
   (sqlite . t)
   (scheme .t)
   (python . t)
   (forth . t)
   (makefile . t)
   (perl . t)
   (shell . t)
   (ditaa . t)
   (C . t) 
   (dot . t)))

(use-package ack)
(use-package google-translate)
(use-package gruvbox-theme)
(use-package elpy
  :ensure t
  :init
  (elpy-enable))
(use-package tree-sitter :ensure t)
(use-package tree-sitter-langs :ensure t)
(use-package tree-sitter-indent :ensure t)
(use-package csharp-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.cs\\'" . csharp-tree-sitter-mode)))

;(use-package centaur-tabs
;  :demand
;  :config
;  (centaur-tabs-mode t)
;  :bind
;  ("C-<prior>" . centaur-tabs-backward)
;  ("C-<next>" . centaur-tabs-forward))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(cmake-ide ob-tangle tuareg haskell-mode websocket use-package rustic projectile magit lua-mode lsp-mode gruvbox-theme google-translate go-errcheck go-eldoc flycheck erc cpupower beacon auctex ada-ref-man ada-mode ack))
 '(warning-suppress-types
   '((comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
