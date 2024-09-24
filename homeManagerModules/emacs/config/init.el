(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
      "straight/repos/straight.el/bootstrap.el"
      (or (bound-and-true-p straight-base-dir)
  	  user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
       'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Set up use-package to use straight.el
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(use-package evil
  :hook ((prog-mode text-mode) . display-line-numbers-mode)
  :custom
  (display-line-numbers-type 'relative)
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-want-C-i-jump nil)
  (evil-respect-visual-line-mode t)
  (evil-want-Y-yank-to-eol t)
  :init
  (global-visual-line-mode)
  (evil-mode))

;; Keybind collection for evil
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Evil Org - Mostly For Agenda
(use-package evil-org
  :after evil org
  :hook
  (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil
  :custom
  (evil-undo-system 'undo-fu))

(use-package undo-fu
  :custom
  (undo-limit 67108864)
  (undo-strong-limit 100663296)
  (undo-outer-limit 1006632960))

(use-package general
  :config
  (general-evil-setup)

  (general-create-definer nj/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  (nj/leader-keys
    "/" '(find-file :wk "goto file")
    ">" '(:ignore t :wk "goto")
    "> r" '(recentf :wk "goto recent file")
    "> m" '(bookmark :wk "goto bookmark")
    "f" '(:ignore t :wk "find")
    "f f" '(find-file :wk "find file")
    "f r" '(recentf :wk "find recent")
    "f m" '(bookmark :wk "find bookmark")
    "x" '(execute-extended-command :wk "M-x")
    "C-/" '(comment-line :wk "comment lines"))

  (nj/leader-keys
    "TAB" '(evil-window-next :wk "next window"))

  ;; buffer keybinds
  (nj/leader-keys
    "b" '(:ignore t :wk "buffer")
    "b b" '(counsel-switch-buffer :wk "switch to buffer")
    "b i" '(ibuffer :wk "ibuffer")
    "b k" '(kill-this-buffer :wk "kill buffer")
    "b n" '(next-buffer :wk "next buffer")
    "b p" '(previous-buffer :wk "previous buffer")
    "b r" '(revert-buffer :wk "reload buffer"))

  ;; bookmarks
  (nj/leader-keys
    "m" '(:ignore t :wk "bookmarks")
    "m d" '(bookmark-delete :wk "delete bookmark")
    "m l" '(bookmark-bmenu-list :wk "bookmark list")
    "m m" '(bookmark-set :wk "add bookmark")
    "m M" '(bookmark-set-no-overwrite :wk "add permanent bookmark")))

(use-package which-key
  :diminish
  :init
  (which-key-mode 1)
  :custom
  (which-key-idle-delay 0.8)
  (which-key-allow-imprecise-window-fit nil))

(use-package vertico
  :ensure t
  :bind (:map vertico-map
  	    ("C-j" . vertico-next)
  	    ("C-k" . vertico-previous)
              ("<tab>" . vertico-insert))
  :custom
  (vertico-cycle t)
  (vertico-count 10)
  (vertico resize t)
  :init
  (vertico-mode))

(use-package emacs
:custom
;; Support opening new minibuffers from inside existing minibuffers.
(enable-recursive-minibuffers t)
;; Emacs 28 and newer: Hide commands in M-x which do not work in the current
;; mode.  Vertico commands are hidden in normal buffers. This setting is
;; useful beyond Vertico.
(read-extended-command-predicate #'command-completion-default-include-p)
(read-file-name-completion-ignore-case t)
(read-buffer-completion-ignore-case t)
(completion-ignore-case t)
:init
;; Add prompt indicator to `completing-read-multiple'.
;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
(defun crm-indicator (args)
  (cons (format "[CRM%s] %s"
                (replace-regexp-in-string
                 "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                 crm-separator)
                (car args))
        (cdr args)))
(advice-add #'completing-read-multiple :filter-args #'crm-indicator)

;; Do not allow the cursor in the minibuffer prompt
(setq minibuffer-prompt-properties
      '(read-only t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))

(use-package savehist
  :init (savehist-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)  ;; Enable cycling for `corfu-next' and `corfu-previous'.
  (corfu-auto t)  ;; Enable auto completion.
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0)
  :bind (:map corfu-map
          ("TAB" . corfu-next)
          ([tab] . corfu-next)
          ("S-TAB" . corfu-previous)
          ([backtab] . corfu-previous))
  :init
  (global-corfu-mode)
  (corfu-history-mode))

(use-package emacs
  :custom
  (tab-always-indent 'complete))

(use-package dabbrev
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  :config
  (add-to-list 'dabbrev-ignored-buffer-regexps "\\` ")
  (add-to-list 'dabbrev-ignored-buffer-modes 'doc-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'pdf-view-mode)
  (add-to-list 'dabbrev-ignored-buffer-modes 'tags-table-mode))

(use-package marginalia
  :after vertico
  :ensure t
  :custom 
  (marginalia-align 'right)
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package nerd-icons)

(use-package nerd-icons-completion
  :config
  (nerd-icons-completion-mode))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  :custom
  (initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name))) ;; open dashboard for emacs clients
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  (dashboard-items '((recents . 8)
  		   (bookmarks . 5)
  		   (projects . 5)
  		   (agenda . 5)))
  (dashboard-navigation-cycle t) ;; cycle through nav headers
  ;; dashboard icons
  (dashboard-display-icons-p t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-projects-backend 'projectile)
  )

(use-package doom-themes
  :config
  (load-theme 'doom-tokyo-night t))

(use-package emacs
  :init
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  :custom
  (scroll-margin 6)
  (scroll-conservatively 40)
  (inhibit-startup-message t))

(use-package doom-modeline
  :custom
  (doom-modeline-total-line-number t)
  :init
  (doom-modeline-mode 1))

(use-package emacs
  :config
  (set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 120))

;; ligature support
(use-package ligature
  :config  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                     ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                     "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                     "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                     "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                     "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                     "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                     "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                     ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                     "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                     "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                     "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                     "\\\\" "://"))
  (global-ligature-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package recentf
  :init
  (recentf-mode 1))

(use-package emacs
  :config
  (save-place-mode 1)
  (global-auto-revert-mode 1) ;; Revert buffers if file is edited outside of emacs instance
  :custom
  (backup-directory-alist `(("." . "~/.temp"))
        backup-by-copying t))

(use-package nov
  :after org) ;; required to maintain single org version

(use-package magit
  :config
  (nj/leader-keys
    "g" '(:ignore t :wk "git")
    "g s" '(magit-status :wk "magit status")))

(use-package project) ;; needed for fix with eglot

(use-package projectile
  :diminish
  :config (projectile-mode 1)
  (nj/leader-keys ;; keybinds
    "p" '(projectile-command-map :wk "projectile"))
  (setq projectile-project-search-path '("~/projects/")))

(use-package rg) ;; ripgrep for use with projectile

(use-package treemacs)
(use-package treemacs-evil)
(use-package treemacs-nerd-icons
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package tree-sitter
  :ensure t
  :hook
  (tree-sitter-after-on-hook . tree-sitter-hl-mode)
  :init
  (global-tree-sitter-mode))
;; install langs
(use-package tree-sitter-langs
  :ensure t)

(use-package emacs
  :hook
  (prog-mode . electric-pair-mode)
  (prog-mode . electric-quote-mode))

(use-package tree-sitter
  :mode
  ("\\.ts\\'" . typescript-ts-mode)
  ("\\.tsx\\'" . tsx-ts-mode)
  ("\\.js\\'" . js-ts-mode)
  ("\\.jsx\\'" . tsx-ts-mode))

;; (use-package eglot
;;   :hook
;;   (tsx-ts-mode . eglot-ensure)
;;   (typescript-ts-mode . eglot-ensure))

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs '((js-ts-mode typescript-ts-mode) . (eglot-deno "deno" "lsp")))

  (defclass eglot-deno (eglot-lsp-server) ()
    :documentation "A custom class for deno lsp.")

  (cl-defmethod eglot-initialization-options ((server eglot-deno))
    "Passes through required deno initialization options"
    (list :enable t
	  :lint t)))

(use-package nix-ts-mode
  :mode "\\.nix\\'")

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs '(nix-ts-mode . ("nil")))
  :hook
  (nix-ts-mode . eglot-ensure))

(use-package apheleia
  :init
  (setq-default indent-tabs-mode nil)
  (apheleia-global-mode +1))

(use-package yasnippet
  :config
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets"))

(use-package org
  :hook (org-mode . org-indent-mode)
  :config
  (require 'org-tempo)
  (nj/leader-keys
    "o" '(:ignore t :wk "org")
    "o e" '(org-edit-special :wk "edit")))

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :custom
  (org-modern-todo nil)
  (org-modern-tag nil)
  (org-modern-timestamp nil)
  (org-modern-star 'replace))

(use-package org
  :config
  (nj/leader-keys
    "o a" '(org-agenda :wk "agenda"))
  :custom
  (org-agenda-files (directory-files-recursively org-directory "\.org$"))
  (org-agenda-custom-commands
   '(("p" "Planning"
      ((tags-todo "+@planning"
                  ((org-agenda-overriding-header "Planning Tasks")))
       (tags-todo "-{.*}"
                  ((org-agenda-overriding-header "Untagged Tasks")))))

     ("i" "Inbox"
      ((todo ""
             ((org-agenda-files '("~/org/inbox.org"))
              (org-agenda-overriding-header "Unprocessed Inbox Items")))))

     ("P" "Projects"
      ((todo ""
      ((org-agenda-files (directory-files-recursively "~/org/projects" "\.org$")
                         ((org-agenda-overriding-header "Projects")))))))

     ("N" "Search" search ""))))

(use-package org
  :config
  (nj/leader-keys
    "o x" '(:ignore t :wk "archive")
    "o x a" '(org-archive-subtree-default :wk "archive default"))
  :custom
  (org-archive-location "~/org/archive.org::* %s"))

(use-package org
  :config
  (nj/leader-keys
    "o c" '(org-capture :wk "capture"))
  :custom
  (org-capture-templates
   '(("t" "Task Entries")
     ("tq" "Quick Task" entry
      (file+olp+datetree "inbox.org")
      "* TODO %^{Task}\n%?")
     ("tr" "Reference Task" entry
      (file+olp+datetree "inbox.org")
      "* TODO %^{Task}\n%A\n%?")

     ("c" "Contact Info")
     ("cF" "Family" entry
      (file+headline "life/contacts.org" "Family")
      "* %^{Name SURNAME}\n :PROPERTIES:\n :RELATIONSHIP: %^{Relationship}\n :PHONE: %^{Number}\n :EMAIL: %^{Email}\n :BORN: %^{Birthday}t\n :END:\n%?")
     )))

(use-package org
  :custom
  (org-refile-targets '((org-agenda-files :maxlevel . 3)))
  :config
  (nj/leader-keys
    "o r" '(:ignore t :wk "refile")
    "o r f" '(org-refile :wk "refile")
    "o r c" '(org-refile-copy :wk "refile copy")
    ))



(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/org/notes")
  :config
  (nj/leader-keys
    "o n" '(:ignore t :wk "org note")
    "o n f" '(org-roam-node-find :wk "org note find")
    "o n i" '(org-roam-node-insert :wk "org note insert")
    )
  (org-roam-setup))

(use-package org-roam-ui)

(use-package toc-org
  :commands toc-org-enable
  :hook (org-mode . toc-org-enable))

(use-package org
  :config
  (nj/leader-keys
    "o q" '(org-set-tags-command :wk "set tags"))
  :custom
  (org-tag-alist
   '(
     ;; Settings
     ("@home" . ?H)
     ("@work" . ?W)
     ("@car" . ?A)

     ;; Devices
     ("@computer" . ?C)
     ("@phone" . ?P)
     ("@server" . ?S)

     ;; Task Types
     ("@planning" . ?p)
     ("@development" . ?d)
     ("@errands" . ?r)
     ("@service" . ?s)
     ("@creative" . ?c)

     ;; Events
     ("@birthday" . ?B)
     ("@wedding" . ?W)
     ("@anniversary" . ?V)
     )))

(use-package org
  :config
  (nj/leader-keys
    "o t" '(org-todo :wk "todo"))
  :custom
  (org-todo-keywords '((sequence "TODO(t)" "ACTIVE(a)" "WAITING(w)" "|" "DONE(d)")))
  (org-log-done 'time))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode))

(add-to-list 'load-path "~/nix/homeManagerModules/emacs/config/")
(require 'openai)
(setenv "OPENAI_API_KEY" "36w5pX1w0J9aaslnofhIb2SMfu9ZjM04")
