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
  :init
  (setq evil-want-integration t
      evil-want-keybinding nil
      evil-want-C-i-jump nil
      evil-respect-visual-line-mode t
      evil-want-Y-yank-to-eol t)
  (evil-mode))

;; Keybind collection for evil
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :config
  (general-evil-setup)

  (general-define-key
   "C-=" 'text-scale-increase
   "C--" 'text-scale-decrease)

  ;; leader key definer
  (general-create-definer nj/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC") ;; non evil buffers

  ;; nav and command keybinds
  (nj/leader-keys
    "x" '(counsel-M-x :wk "command")
    "/" '(find-file :wk "goto file")
    ">" '(:ignore t :wk "goto")
    "> r" '(counsel-recentf :wk "goto recent file")
    "> m" '(counsel-bookmark :wk "goto bookmark")
    "> c" '((lambda () (interactive) (find-file "~/.config/emacs/config.org")) :wk "goto emacs config")
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

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
       :map ivy-minibuffer-map
       ("TAB" . ivy-alt-done)
       ("C-l" . ivy-alt-done)
       ("C-j" . ivy-next-line)
       ("C-k" . ivy-previous-line)
       :map ivy-switch-buffer-map
       ("C-k" . ivy-previous-line)
       ("C-l" . ivy-done)
       ("C-d" . ivy-switch-buffer-kill)
       :map ivy-reverse-i-search-map
       ("C-k" . ivy-previous-line)
       ("C-d" . ivy-reverse-search-i-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :diminish
  :after ivy
:bind (("M-x" . counsel-M-x)
       ("C-x b" . counsel-ibuffer)
       ("C-x C-f" . counsel-find-file)
       :map minibuffer-local-map
       ("C-r" . 'counsel-minibuffer-history)))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :after all-the-icons-ivy-rich
  :after counsel
  :ensure t
  :init (ivy-rich-mode 1)) ;; this gets us descriptions in M-x.

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #' helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key)
  :config
  (nj/leader-keys
    "h" '(:ignore t :wk "help")
    "h f" '(describe-function :wk "describe function")
    "h v" '(describe-variable :wk "describe variable")))

(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)  ;; Enable cycling for `corfu-next' and `corfu-previous'.
  (corfu-auto t)  ;; Enable auto completion.
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.2)

  :bind (:map corfu-map
          ("TAB" . corfu-next)
          ([tab] . corfu-next)
          ("S-TAB" . corfu-previous)
          ([backtab] . corfu-previous))
  :init
  (global-corfu-mode))

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(use-package hydra)

(use-package recentf
  :config
  (recentf-mode)
  (add-to-list 'recentf-exclude
  	     "~/.config/emacs/.cache/*"))

(use-package sudo-edit
  :config
  (nj/leader-keys
    "s" '(:ignore t :wk "sudo")
    "s /" '(sudo-edit-find-file :wk "sudo find file")
    "s ." '(sudo-edit :wk "sudo edit current file")))

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))
(use-package all-the-icons-dired ;; ATI Dired Support
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(use-package dashboard
  :ensure t
  :init
  (setq initial-buffer-choice 'dashboard-open)
  :custom
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-center-content t) 
  (dashboard-projects-backend 'projectile)
  (dashboard-items '((recents . 8)
                          (agenda . 6)
                          (bookmarks . 6)
                          (projects . 8)))
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book")))
  :config
  (dashboard-setup-startup-hook))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)) 
(use-package diminish) ;; Adds ability to diminish modes from modeline

(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/")
(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-horizon t))

;;create font default
(set-face-attribute 'default nil
  :font "FiraCodeNerdFont"
  :weight 'regular)

;;make comments italicized
(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)

;;make keywords italicized
(set-face-attribute 'font-lock-keyword-face nil
  :slant 'italic)

;;add font to default
(add-to-list 'default-frame-alist '(font . "FiraCode-12"))

(set-face-attribute 'variable-pitch nil
                    :font "FiraSans"
                    :height 325
                    :weight 'regular)

;;set line spacing
(setq-default line-spacing 0.20)

;; disable gui bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-fringe-mode 10)

;; disable startup screen
(setq inhibit-startup-screen t)  

;; relative line numbering
(setq display-line-numbers-type 'relative)

;; visual line mode
(visual-line-mode t)

;; zoom on scroll
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; scroll margin
(setq scroll-margin 6)
(setq scroll-conservatively 100)

(use-package ellama
  :init
  (setopt ellama-keymap-prefix "C-c e")
  (require 'llm-ollama)
  :config
  (setq ellama-session-auto-save nil)
  (nj/leader-keys
    "e" '(:ignore t :wk "ellama")
    "e c" '(:ignore t :wk "code")
    "e c a" '(ellama-code-add :wk "ellama add code")
    "e c c" '(ellama-code-complete :wk "ellama code complete")
    "e c r" '(ellama-code-review :wk "ellama code review")
    "e c r" '(ellama-code-edit :wk "ellama code edit")
    "e C" '(ellama-complete :wk "ellama complete")
    "e e" '(ellama-chat :wk "ellama chat")))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :bind (:map flycheck-mode-map
  	    ("M-n" . flycheck-next-error)
  	    ("M-p" . flycheck-previous-error)))

(use-package magit
  :config
  (nj/leader-keys
    "g" '(:ignore t :wk "git")
    "g s" '(magit-status :wk "magit status")))

(use-package projectile
  :diminish
  :config (projectile-mode 1)
  (nj/leader-keys ;; keybinds
    "p" '(projectile-command-map :wk "projectile"))
  (setq projectile-project-search-path '("~/projects/")))

(use-package tree-sitter
      :mode (("\\.tsx\\'" . tsx-ts-mode)
             ("\\.ts\\'"  . typescript-ts-mode)
             ("\\.json\\'" .  json-ts-mode)
             ;; More modes defined here...
             )
      :preface
      ;; Optional, but recommended. Tree-sitter enabled major modes are
      ;; distinct from their ordinary counterparts.
      ;;
      ;; You can remap major modes with `major-mode-remap-alist'. Note
      ;; that this does *not* extend to hooks! Make sure you migrate them
      ;; also
      (dolist (mapping
               '((python-mode . python-ts-mode)
                 (css-mode . css-ts-mode)
                 (typescript-mode . typescript-ts-mode)
                 (js-mode . typescript-ts-mode)
                 (js2-mode . typescript-ts-mode)
                 (c-mode . c-ts-mode)
                 (c++-mode . c++-ts-mode)
                 (c-or-c++-mode . c-or-c++-ts-mode)
                 (bash-mode . bash-ts-mode)
                 (css-mode . css-ts-mode)
                 (json-mode . json-ts-mode)
                 (js-json-mode . json-ts-mode)
                 (sh-mode . bash-ts-mode)
                 (sh-base-mode . bash-ts-mode)))
        (add-to-list 'major-mode-remap-alist mapping))
      :config
      (os/setup-install-grammars))

(use-package lsp-mode
  :diminish "LSP"
  :ensure t
  :hook ((lsp-mode . lsp-diagnostics-mode)
         (lsp-mode . lsp-enable-which-key-integration)
         ((tsx-ts-mode
           typescript-ts-mode
           js-ts-mode) . lsp-deferred))
  :custom
  (lsp-keymap-prefix "C-c l")           ; Prefix for LSP actions
  (lsp-completion-provider :none)       ; Using Corfu as the provider
  (lsp-diagnostics-provider :flycheck)
  (lsp-session-file (locate-user-emacs-file ".lsp-session"))
  (lsp-log-io nil)                      ; IMPORTANT! Use only for debugging! Drastically affects performance
  (lsp-keep-workspace-alive nil)        ; Close LSP server if all project buffers are closed
  (lsp-idle-delay 0.5)                  ; Debounce timer for `after-change-function'
  ;; core
  (lsp-enable-xref t)                   ; Use xref to find references
  (lsp-auto-configure t)                ; Used to decide between current active servers
  (lsp-eldoc-enable-hover t)            ; Display signature information in the echo area
  (lsp-enable-dap-auto-configure t)     ; Debug support
  (lsp-enable-file-watchers nil)
  (lsp-enable-folding nil)              ; I disable folding since I use origami
  (lsp-enable-imenu t)
  (lsp-enable-indentation nil)          ; I use prettier
  (lsp-enable-links nil)                ; No need since we have `browse-url'
  (lsp-enable-on-type-formatting nil)   ; Prettier handles this
  (lsp-enable-suggest-server-download t) ; Useful prompt to download LSP providers
  (lsp-enable-symbol-highlighting t)     ; Shows usages of symbol at point in the current buffer
  (lsp-enable-text-document-color nil)   ; This is Treesitter's job

  (lsp-ui-sideline-show-hover nil)      ; Sideline used only for diagnostics
  (lsp-ui-sideline-diagnostic-max-lines 20) ; 20 lines since typescript errors can be quite big
  ;; completion
  (lsp-completion-enable t)
  (lsp-completion-enable-additional-text-edit t) ; Ex: auto-insert an import for a completion candidate
  (lsp-enable-snippet t)                         ; Important to provide full JSX completion
  (lsp-completion-show-kind t)                   ; Optional
  ;; headerline
  (lsp-headerline-breadcrumb-enable t)  ; Optional, I like the breadcrumbs
  (lsp-headerline-breadcrumb-enable-diagnostics nil) ; Don't make them red, too noisy
  (lsp-headerline-breadcrumb-enable-symbol-numbers nil)
  (lsp-headerline-breadcrumb-icons-enable nil)
  ;; modeline
  (lsp-modeline-code-actions-enable nil) ; Modeline should be relatively clean
  (lsp-modeline-diagnostics-enable nil)  ; Already supported through `flycheck'
  (lsp-modeline-workspace-status-enable nil) ; Modeline displays "LSP" when lsp-mode is enabled
  (lsp-signature-doc-lines 1)                ; Don't raise the echo area. It's distracting
  (lsp-ui-doc-use-childframe t)              ; Show docs for symbol at point
  (lsp-eldoc-render-all nil)            ; This would be very useful if it would respect `lsp-signature-doc-lines', currently it's distracting
  ;; lens
  (lsp-lens-enable nil)                 ; Optional, I don't need it
  ;; semantic
  (lsp-semantic-tokens-enable nil)      ; Related to highlighting, and we defer to treesitter

  :init
  (setq lsp-use-plists t))

;; (use-package lsp-completion
;;   :no-require
;;   :hook ((lsp-mode . lsp-completion-mode)))
(use-package lsp-ui
  :ensure t
  :commands
  (lsp-ui-doc-show
   lsp-ui-doc-glance)
  :bind (:map lsp-mode-map
  	    ("C-c C-d" . 'lsp-ui-doc-glance))
  :after (lsp-mode evil)
  :config (setq lsp-ui-doc-enable t
                evil-lookup-func #'lsp-ui-doc-glance ; Makes K in evil-mode toggle the doc for symbol at point
                lsp-ui-doc-show-with-cursor nil      ; Don't show doc when cursor is over symbol - too distracting
                lsp-ui-doc-include-signature t       ; Show signature
                lsp-ui-doc-position 'at-point))

;; optionally
;; (use-package lsp-ui :commands lsp-ui-mode)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

(use-package rust-mode
  :mode "\\.rs\\'")

(use-package nix-mode
  :hook (nix-mode . lsp-deferred)
  :mode "\\.nix\\'")

(use-package prettier
  :hook (tsx-ts-mode))

(use-package yasnippet
 :config
  (yas-global-mode 1))

(use-package treemacs
  :defer t
  :diminish
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-width 28)
    (treemacs-follow-mode t)
    (treemacs-project-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-`"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))

(use-package treemacs-magit
  :after (treemacs magit))

(use-package treemacs-all-the-icons
  :after (treemacs all-the-icons)
  :config (treemacs-load-theme "all-the-icons"))

(use-package treemacs-tab-bar
  :after (treemacs)
  :config (treemacs-set-scope-type 'Tabs))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode
  :diminish
  :hook 
  ((org-mode prog-mode) . rainbow-mode))

(defun nj/vterm-close ()
  (interactive)
    (vterm-clear)
    (evil-window-delete))

(use-package vterm
  :config
  (add-to-list 'display-buffer-alist
  	     '("\*vterm\*"
  	       (display-buffer-in-side-window)
  	       (window-height . 0.25)
  	       (side . bottom)
  	       (slot . 0)))
  (nj/leader-keys
"v" '(vterm :wk "open vterm"))
(define-key vterm-mode-map (kbd "C-<escape>") 'nj/vterm-close))

(use-package org
  :hook (org-mode . visual-line-mode)
  :config
  (require 'org-tempo) ;; allows for quick block execution
  ;; Keybinds
  (nj/leader-keys
    "o" '(:ignore t :wk "org mode")
    ;; agenda
    "o a" '(org-agenda :wk "org agenda")
    ;; edit src
    "o e" '(org-edit-special :wk "org edit")
    "o s" '(org-edit-src-exit :wk "org exit edit")
    "o c" '(org-edit-src-abort :wk "org abort edit")
    ;; tags
    "o q" '(org-set-tags-command :wk "org add tags"))

    ;; org-todo/agenda
    (setq org-agenda-files
    	'("~/documents/org/projects.org"))

    (setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
    			  (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")
  			  (sequence "WANT(w)" "|" "HAVE")))

    (setq org-tag-alist
    	'(;; Spaces
    	  ("@home" . ?H)
    	  ("@work" . ?W)
    	  ;; Devices
    	  ("@phone" . ?P)
    	  ("@computer" . ?c)

    	  ;; Activities
    	  ("@planning" . ?p)
    	  ("@dev" . ?d)
    	  ("@errands" . ?e)
    	  ("@social" . ?s)
    	  ("@calls" . ?C)
    	  ))

  :custom
   (org-hide-emphasis-markers nil)
   (org-startup-indented t) ;; match indentions
   ;; org src-blocks
   (org-src-fontify-natively t)
   (org-src-tab-acts-natively t))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package toc-org
  :hook (org-mode . toc-org-mode))
