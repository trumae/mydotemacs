(setq user-mail-address "trumae@gmail.com")
(setq user-full-name "Trumae da Ilha")

(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")

(menu-bar-mode 0)
(column-number-mode 1)
(global-hl-line-mode 0)
(show-paren-mode 1)

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


(use-package lsp-mode)
(use-package markdown-mode)

;(use-package 'yasnippet
;  :ensure t)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  )
(setq flycheck-checker-error-threshold 1000) 

(use-package projectile)

(use-package go-eldoc)
(use-package go-errcheck)
(use-package go-mode)
;;(require 'go-mode-load)
;(add-hook 'before-save-hook 'gofmt-before-save)
;(add-hook 'go-mode-hook (lambda ()
;                          (local-set-key (kbd \"M-.\") 'godef-jump)))
;(add-mode-hook 'go-mode-hook (lambda ()
;			       (setq tab-width 4)))

(add-hook 'go-mode-hook #'lsp)
(add-hook 'go-mode-hook (lambda ()
			  (company-mode) ; enable company upon activating go
			  ;;(set (make-local-variable 'company-backends) '(company-go))
			  
			  ;; Code layout.
			  (setq tab-width 2 indent-tabs-mode 1) ; std go whitespace configuration
			  (add-hook 'before-save-hook 'gofmt-before-save) ; run gofmt on each save
			  
			  ;; Fix parsing of error and warning lines in compiler output.
			  (setq compilation-error-regexp-alist-alist ; first remove the standard conf; it's not good.
				(remove 'go-panic
					(remove 'go-test compilation-error-regexp-alist-alist)))))

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
(use-package org-trello)
(use-package ack)
(use-package google-translate)
(use-package gruvbox-theme)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-trello-current-prefix-keybinding "C-c o" nil (org-trello))
 '(package-selected-packages
   '(gruvbox-theme google-translate ack org-trello lua-mode beacon magit go-errcheck go-eldoc flycheck lsp-mode use-package tuareg slime projectile haskell-mode flx-ido)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
