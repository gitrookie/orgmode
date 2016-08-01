;; Package Installer Details
(require 'package)
(add-to-list 'package-archives '("melpa-stable"
				 . "http://stable.melpa.org/packages/"))
(package-initialize)

;; User Details
;; user-full-name is full name of the user logged in. Here overridden by setq special form.
;; Original value was gaurav.
(setq user-full-name "Gaurav Sood")
(setq user-mail-address "imgauravsood@gmail.com")

;; Global Settings
(column-number-mode)
(global-auto-revert-mode)
(global-linum-mode)
(global-company-mode)
(projectile-global-mode)
(helm-projectile-on)
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.backemacs"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)
(setq-default fill-column 80)
(add-hook 'text-mode-hook
  '(lambda() (set-fill-column 80)))
(global-flycheck-mode)
(electric-pair-mode)
(company-quickhelp-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(highlight-parentheses-mode)
(if (display-graphic-p)
    (load-theme 'atom-one-dark t))
(global-set-key (kbd "C-c C-u") 'uncomment-region)
(global-set-key (kbd "C-c C-m") 'comment-region)

;; Haskell
(add-hook 'haskell-mode-hook 'intero-mode)

;; Python
(require `company)
(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook 'my/python-mode-hook)
(pyvenv-mode)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
(add-hook 'python-mode-hook
	  '(lambda ()
	     (local-set-key (kbd "C-c .") 'jedi:goto-definition)
	     (local-set-key (kbd "C-c ,") 'jedi:goto-definition-pop-marker)
	     (local-set-key (kbd "C-c d") 'jedi:show-doc)
	     (local-set-key (kbd "C-<tab>") 'jedi:complete)))

;;Git
(require `magit)

;;Org Mode
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ditaa . t) (perl . t) (emacs-lisp . t) (python . t) (haskell . t) (C . t) (js . t)))
(add-hook 'org-mode-hook
          (lambda()
            (flyspell-mode 1)))
(defun my-org-mode-hook ()
  (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))
(add-hook 'org-mode-hook #'my-org-mode-hook)
