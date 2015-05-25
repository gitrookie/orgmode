(setq url-proxy-services
   '(("no_proxy" . "^\\(localhost\\|10.*\\)")
     ("http" . "web-proxy.atl.hp.com:8080")
     ("https" . "web-proxy.atl.hp.com:8080")))

(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
("melpa" . "http://stable.melpa.org/packages/")))
(package-initialize)

;; User details
(setq user-full-name "Gaurav Sood")
(setq user-mail-address "gaurav.sood031@gmail.com")

;; Environment
(require 'cl)

(defvar gaurav/packages '(ac-slime
			  auto-complete
			  auto-complete-c-headers
			  autopair
			  color-theme-solarized
			  elpy
			  ac-haskell-process
			  flycheck-ghcmod
			  flycheck-haskell
			  flymake-haskell-multi
			  dsvn
			  projectile
			  helm-projectile
			  ctags
			  magit
			  haskell-mode
			  )
  "Default packages")

(defun gaurav/packages-installed-p ()
  (loop for pkg in gaurav/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (gaurav/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg gaurav/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)

(scroll-bar-mode -1)
;; (tool-bar-mode -1)
;; (menu-bar-mode -1)

(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (set-face-attribute 'default nil
                      :family "DejaVu Sans Mono"
                      :height 120
                      :weight 'normal
                      :width 'normal)

  (when (functionp 'set-fontset-font)
    (set-fontset-font "fontset-default"
                      'unicode
                      (font-spec :family "DejaVu Sans Mono"
                                 :width 'normal
                                 :size 12.4
                                 :weight 'normal))))

(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

(setq tab-width 4
      indent-tabs-mode nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)

(setq column-number-mode t)

(require 'autopair)

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

(setq-default show-trailing-whitespace t)

(if window-system
    (load-theme 'solarized-light t)
  (load-theme 'wombat t))

(add-hook 'after-init-hook #'global-flycheck-mode)

;; Python Environment
(elpy-enable)

;; Haskell Environment
;; (require 'haskell-mode-autoloads)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)

(add-hook 'haskell-mode-hook 'haskell-indentation-mode)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(setq haskell-process-log t)

;;C/C++ environment
(require 'auto-complete-c-headers)
(add-to-list 'ac-sources 'ac-source-c-headers)
(require 'cc-mode)

;;Projectile Settings
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (org-ac helm-projectile projectile magit flymake-haskell-multi flycheck-haskell flycheck-ghcmod elpy dsvn ctags color-theme-solarized autopair auto-complete-c-headers async ac-slime ac-haskell-process))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; emacs Backup Directory
(setq backup-directory-alist '(("." . "~/backup_emacs")))


(require 'dsvn)

(require 'org-ac)
(org-ac/config-default)

(add-hook 'org-mode-hook
  (lambda()
    (flyspell-mode 1)))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

(require 'magit)

(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")
