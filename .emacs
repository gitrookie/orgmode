
;; start package.el with emacs
(require 'package)
; add MELPA to repository list
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
;intialize package.el
(package-initialize)

;; User Details
(setq user-full-name "Gaurav Sood")
(setq user-mail-address "gaurav.sood031@gmail.com")

;; Environment
(setenv "PATH" (concat "/usr/local/bin:/opt/local/bin:/usr/bin:/bin" (getenv "PATH")))
(require 'cl)
(require 'cc-mode)

;; Define default Packages
(defvar gaurav/packages '(ac-slime
			  ahg
			  projectile
			  projectile-codesearch
			  ctags
			  ctags-update
			  etags-table
			  etags-select
			  )
  "Default packages")

;; Install Default Packages
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

(setq tab-width 2
      indent-tabs-mode nil)

(defalias 'yes-or-no-p 'y-or-n-p)


(global-set-key (kbd "RET") 'newline-and-indent)
;(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)

(setq column-number-mode t)

(if window-system
    (load-theme 'solarized-light t)
  (load-theme 'wombat t))

;;To switch between buffers
(windmove-default-keybindings 'meta)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)


(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

(require 'yasnippet)
(yas-global-mode 1)

(defun my:ac-c-header-init()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '"/usr/lib/gcc/x86_64-linux-gnu/4.7/include")
  (add-to-list 'achead:include-directories '"/usr/include/c++/4.7")

)

(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)


(require 'iedit)

;; (add-hook 'c++-mode-hook 
;; 	  (lambda ()
;;     (unless (or (file-exists-p "makefile") (file-exists-p "Makefile"))
;;   (set (make-local-variable 'compile-command)
;;        (concat "make -k "
;;    (file-name-sans-extension buffer-file-name))))))

;(define-key c++-mode-map (kbd "C-c c") 'compile)
(define-key global-map (kbd "C-c u") 'uncomment-region)


(defun my:flymake-google-init()
  (require 'flymake-google-cpplint)
  (custom-set-variables
   '(flymake-google-cpplint-command "/usr/local/bin/cpplint"))
   (flymake-google-cpplint-load)
)

(add-hook 'c-mode-hook 'my:flymake-google-init)
(add-hook 'c++-mode-hook 'my:flymake-google-init)

(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

(semantic-mode 1)
(defun my:add-semantic-to-autocomplete()
  (add-to-list 'ac-sources 'ac-source-semantic)
)
(add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)

(global-ede-mode t)
;;(ede-cpp-root-project "my project" :file "~/Documents/Programming/demo/myprogram/src/main.cpp"
;;		      :include-path '("/../my_inc"))

;;Python
(elpy-enable)

(require 'autopair)
(autopair-global-mode) ;; to enable in all buffers

(which-function-mode 1)

(add-hook 'prog-mode-hook 'paredit-everywhere-mode)

(require 'paren)			;; Highlight matching parenthesis
(setq show-paren-style 'parenthesis)
(show-paren-mode +1)

(define-key global-map (kbd "RET") 'newline-and-indent)


(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; (haskell-decl-scan-mode nil)
;; (add-hook 'flycheck-mode-hook #'flycheck-haskell-setup)
;; (eval-after-load 'flycheck '(require 'flycheck-ghcmod))
(put 'downcase-region 'disabled nil)

;;Projectile
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)


;; CTags
(require 'ctags)
;;(autoload 'turn-on-ctags-auto-update-mode "ctags-update" "turn on `ctags-auto-update-mode'." t)
;;(add-hook 'c-mode-common-hook  'turn-on-ctags-auto-update-mode)
;;(add-hook 'emacs-lisp-mode-hook  'turn-on-ctags-auto-update-mode)

(require 'disaster)
(define-key c-mode-base-map (kbd "C-c d") 'disaster)


;;Backup Directory
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.backemacs"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-babel-load-languages (quote ((clojure . t) (C . t) (haskell . t) (python . t) (emacs-lisp . t))))
 '(package-archives (quote (("melpa-stable" . "http://stable.melpa.org/packages/") ("gnu" . "http://elpa.gnu.org/packages/")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-hook 'after-init-hook #'global-flycheck-mode)

(add-hook 'haskell-mode-hook 'haskell-indentation-mode)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'haskell-decl-scan-mode)
(add-hook 'haskell-mode-hook 'haskell-doc-mode)
;; (require 'flymake-haskell-multi)
;; (add-hook 'haskell-mode-hook 'flymake-haskell-multi-load)
;; (eval-after-load 'haskell-mode
;;   `(define-key haskell-mode-map
;;      (kbd "C-c C-d d")
;;      #'ghc-imported-from-haddock-for-symbol-at-point))
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))



(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
  ;; beamer class, for presentations
  '("beamer"
     "\\documentclass[11pt]{beamer}\n
      \\mode<{{{beamermode}}}>\n
      \\usetheme{{{{beamertheme}}}}\n
      \\usecolortheme{{{{beamercolortheme}}}}\n
      \\beamertemplateballitem\n
      \\setbeameroption{show notes}
      \\usepackage[utf8]{inputenc}\n
      \\usepackage[T1]{fontenc}\n
      \\usepackage{hyperref}\n
      \\usepackage{color}
      \\usepackage{listings}
      \\lstset{numbers=none,language=[ISO]C++,tabsize=4,
  frame=single,
  basicstyle=\\small,
  showspaces=false,showstringspaces=false,
  showtabs=false,
  keywordstyle=\\color{blue}\\bfseries,
  commentstyle=\\color{red},
  }\n
      \\usepackage{verbatim}\n
      \\institute{{{{beamerinstitute}}}}\n          
       \\subject{{{{beamersubject}}}}\n"

     ("\\section{%s}" . "\\section*{%s}")
     
     ("\\begin{frame}[fragile]\\frametitle{%s}"
       "\\end{frame}"
       "\\begin{frame}[fragile]\\frametitle{%s}"
       "\\end{frame}")))

  ;; letter class, for formal letters

  (add-to-list 'org-export-latex-classes

  '("letter"
     "\\documentclass[11pt]{letter}\n
      \\usepackage[utf8]{inputenc}\n
      \\usepackage[T1]{fontenc}\n
      \\usepackage{color}"
     
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
     ("\\paragraph{%s}" . "\\paragraph*{%s}")
     ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
