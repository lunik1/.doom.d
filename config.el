;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-



;;; Global
(setopt display-line-numbers-type 'relative
        x-stretch-cursor t
        truncate-string-ellipsis "…"
        scroll-margin 5
        hscroll-margin 10
        tab-width 4
        save-interprogram-paste-before-kill t
        user-full-name "Corin Hoad"
        user-mail-address "ch.gpg@themaw.xyz"
        ;; get/save auth info to an encrypted file
        auth-sources '("~/.authinfo.gpg")
        ;; cache gpg passphrase
        epa-file-cache-passphrase-for-symmetric-encryption t)

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(remove-hook! '(text-mode-hook prog-mode-hook conf-mode-hook) ; disable fill-column by default
  #'+fill-column-enable-h)

(map! :prefix "C-w"
      :nv "f" 'make-frame-command)
(map! :leader
      "w f" 'make-frame-command)

;; mac likes to force the menu bar
(if (eq system-type 'darwin)
    (menu-bar-mode -1))



;;; DOOM

(defun tem-dashboard-draw-ascii-banner-fn ()
  (let* ((banner
          '("       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠁⠀⠈⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠁⢠⡀⠀⠈⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠁⢠⠃⠘⡄⠀⠘⡆⣰⠞⠉⠉⠙⢦⠀⠀⠀⠀⣀⣀⡤⠤⠤⠖⠒⠲⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠃⠀⢸⠀⠀⠸⡄⠠⡿⠁⠀⠀⣀⡤⣬⣆⡠⠖⠋⠁⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡏⠀⡠⠾⠒⠲⠤⢵⡀⡇⠀⠀⡜⢁⣀⣼⣋⣀⡀⢀⣀⡤⠔⠒⠒⢲⠂⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣤⠋⠀⠀⠀⠀⠀⠀⠈⠻⠄⠸⠟⠉⠀⠀⠀⠀⠈⠙⢦⡀⠀⠀⢀⠏⠀⢰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⡀⢀⠎⠀⢠⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠞⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢷⠁⠀⡰⠋⠀⠀⡴⠒⠲⡄⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠀⠀⠀⠀⣰⠋⠀⠀⠀⠀⠀⠀⠀⣠⠚⠁⠀⠑⠤⠊⠉⠑⢤⡀⠀⠀⠀⠀⠀⠀⢸⠖⠋⠀⠀⠀⢀⡇⠀⠀⢱⣀⠔⠦⣄⠀"
            "       ⠀⠀⠀⠀⠀⢀⡠⠚⠁⠀⠀⠀⠀⠀⠀⣠⠞⠁⣀⣀⠀⠀⠀⠀⠀⠀⠀⠙⢆⠀⠀⠀⠀⠀⠈⣇⠀⠀⠀⠀⠈⢧⠀⠀⠘⠃⠀⠀⠈⢧"
            "       ⠀⠈⠛⢭⣉⠁⠀⠀⠀⠀⠀⣀⣀⡴⠚⠁⠀⠈⠀⠀⠀⠀⠀⠀⠀⠐⠒⠲⡄⠳⡀⠀⠀⠀⠀⠈⠓⠲⠶⡶⠀⠘⣇⠀⠀⠀⠀⠀⠀⡼"
            "       ⠀⠀⠀⣠⠼⠋⠉⢙⡟⠉⠉⠀⡼⠁⠀⠀⠀⠀⣴⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣄⠀⠀⠀⠀⠀⠀⡰⠁⠀⣀⡈⠉⠙⠒⠒⠶⠒⠁"
            "       ⠀⣰⠏⠁⠀⠀⢀⡜⠀⠀⠀⢰⠁⠀⠀⠀⠀⠘⢿⠟⠀⠀⠀⠀⢠⣶⣦⡀⠀⠀⠀⠈⡷⠲⠤⢤⠔⠚⢣⡀⢀⣙⣢⠀⠀⠀⠀⠀⠀⠀"
            "       ⢠⡇⠀⠀⠀⠀⢸⣧⠀⠀⠀⡼⠀⠀⠀⠀⠀⠀⠀⡤⠠⡲⠂⠀⠈⠛⠋⠀⠀⠀⠀⠀⡇⠀⠀⢸⠀⠀⠀⠹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⢸⡄⠀⠀⠀⠀⠸⣟⠀⠀⢰⣧⠀⠀⠀⠀⠀⠀⠀⠙⠛⠳⠦⠃⠀⠀⠀⠀⠀⠀⠀⢸⠃⠀⠀⢸⠀⠀⠀⠀⠹⡄⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠳⣄⡀⠀⠀⣀⣷⣦⠀⢸⡟⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠏⠀⠀⠀⡼⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠉⠉⠉⠁⢿⡿⡄⢸⡇⠈⠓⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⢿⠂⠀⡆⢀⡇⠀⠀⠀⢀⡴⠃⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠀⠀⠀⠀⣿⣳⣸⡷⠀⠀⠀⠈⠙⠒⢤⢤⢤⣤⣀⣠⣤⠤⠴⠒⠉⠀⡏⠀⣰⣻⣾⡗⠒⠒⠒⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣧⣶⡄⠀⢀⣤⠖⠛⢟⢤⣀⣀⣜⡟⢧⣄⠀⣀⠀⡇⢠⣳⣮⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠀⠀⠀⣀⣤⣥⣌⣿⠁⠹⣴⣿⠁⠀⠀⠀⠉⠉⠛⣉⠀⠀⠈⡟⠹⡄⣷⡷⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⢀⣴⠚⠉⠁⠀⠀⠀⠉⠙⠲⢬⡇⠀⠀⠀⠀⡖⠀⢠⠏⠀⠀⠀⡇⠀⢷⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⢸⡧⠀⠀⠀⢀⣠⢴⣒⣒⣤⣵⡏⠀⠀⠀⠀⢳⢀⠏⠁⠀⠀⠀⣇⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠀⠹⢦⡤⠖⠋⡴⠋⠉⠀⠀⠈⣇⠀⠀⠀⠀⢸⣼⠀⠀⠀⠀⠀⡏⠉⠉⠉⠓⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⢀⣠⠤⠶⠒⠒⠾⣇⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⢰⠃⠀⠀⠀⠀⢸⠓⠒⠒⠦⠤⢄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠸⣟⣀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠙⠳⣍⣉⣩⠏⠙⢯⣉⣲⠖⠚⠋⠉⠉⠉⠉⠁⠀⠀⠀⠀⣀⣠⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "       ⠀⠀⠀⠈⠉⠛⠛⠛⠒⠒⠒⠒⠦⠤⠤⠤⠤⠤⣄⣀⣀⣀⣀⣈⣁⣀⣤⠤⠤⠤⠤⠤⠤⠖⠒⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "                                                         "
            "                  T   E   M   A   C   S                  "))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat
                 line (make-string (max 0 (- longest-line (length line)))
                                   32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(setf +doom-dashboard-banner-dir "~/.doom.d/"
      +doom-dashboard-banner-file "tem.png"
      +doom-dashboard-ascii-banner-fn #'tem-dashboard-draw-ascii-banner-fn
      doom-font (font-spec :family "Myosevka" :size 13.0)
      doom-symbol-font (font-spec :family "Julia Mono")
      doom-variable-pitch-font (font-spec :family "Myosevka Etoile" :size 13.0)
      doom-serif-font (font-spec :family "Myosevka Etoile" :size 13.0)
      doom-theme 'doom-gruvbox
      doom-themes-enable-bold t
      doom-themes-enable-italic t)

;; theme tweaks
(custom-set-faces!
  ;;; dark line highlight ()
  '(hl-line :background "#1d2021")
  '(line-number-current-line :background "#1d2021" :weight semi-bold)
  ;;; …that matches solaire mode
  '(solaire-default-face :background "#1d2021"))

;;; theme does not set cursor colour
(set-cursor-color "#ebdbb2")



;;; DOOM modeline
(custom-set-faces!
  '(mode-line :family "Myosevka Proportional")
  '(mode-line-active :family "Myosevka Proportional")
  '(mode-line-inactive :family "Myosevka Proportional"))



;;; Evil
(after! evil
  (setopt evil-emacs-state-cursor '(bar +evil-emacs-cursor-fn)
          evil-escape-key-sequence "kj")

  ;; Add empty line above/below in normal mode with RET/S-RET
  (defun insert-line-below (n)
    "Insert an empty line below the current line."
    (interactive "p")
    (evil-open-below n)
    (evil-normal-state))

  (defun insert-line-above (n)
    "Insert an empty line above the current line."
    (interactive "p")
    (evil-open-above n)
    (evil-normal-state))

  (map! :n "<RET>"      'insert-line-below
        :n "S-<return>" 'insert-line-above)

  ;; Define quote textobkect so diq etc. works inside any kind of quotes
  (use-package! evil-textobj-anyblock)
  (evil-define-text-object my-evil-textobj-anyblock-inner-quote
    (count &optional beg end _type)
    "Select the closest outer quote."
    (let ((evil-textobj-anyblock-blocks
           '(("'" . "'")
             ("\"" . "\"")
             ("«" . "»")
             ("`" . "`")
             ("“" . "”"))))
      (evil-textobj-anyblock--make-textobj beg end type count nil)))

  (evil-define-text-object my-evil-textobj-anyblock-a-quote
    (count &optional beg end _type)
    "Select the closest outer quote."
    (let ((evil-textobj-anyblock-blocks
           '(("'" . "'")
             ("\"" . "\"")
             ("«" . "»")
             ("`" . "`")
             ("“" . "”"))))
      (evil-textobj-anyblock--make-textobj beg end type count t)))

  (define-key evil-inner-text-objects-map "q"
              'my-evil-textobj-anyblock-inner-quote)
  (define-key evil-outer-text-objects-map "q"
              'my-evil-textobj-anyblock-a-quote)

  ;; more digraphs
  (setopt evil-digraphs-table-user '(((?* ?e) . ?ϵ)
                                     ((?* ?f) . ?ϖ)
                                     ((?* ?h) . ?ϑ)
                                     ((?* ?r) . ?ϱ)
                                     ((?, ?.) . ?…)
                                     ((?| ?>) . ?↦) ; \mapsto
                                     ((?< ?|) . ?↤)
                                     ((?/ ?E) . ?∄)
                                     ((?h ?-) . ?ℏ)))
  (map! :leader
        :after evil
        "w SPC"         'rotate-layout
        "w <left>"      'evil-window-left
        "w <right>"     'evil-window-right
        "w <up>"        'evil-window-up
        "w <down>"      'evil-window-down
        "w C-<left>"    'evil-window-left
        "w C-<right>"   'evil-window-right
        "w C-<up>"      'evil-window-up
        "w C-<down>"    'evil-window-down
        "w S-<left>"    '+evil/window-move-left
        "w S-<right>"   '+evil/window-move-right
        "w S-<up>"      '+evil/window-move-up
        "w S-<down>"    '+evil/window-move-down
        "w C-S-<left>"  'evil-window-move-far-left
        "w C-S-<right>" 'evil-window-move-far-right
        "w C-S-<up>"    'evil-window-move-very-top
        "w C-S-<down>"  'evil-window-move-very-bottom)

  ;; navigate windows with C-w + arrow keys
  (map! :prefix "C-w"
        :after evil
        :nv "<left>"      'evil-window-left
        :nv "<right>"     'evil-window-right
        :nv "<up>"        'evil-window-up
        :nv "<down>"      'evil-window-down
        :nv "C-<left>"    'evil-window-left
        :nv "C-<right>"   'evil-window-right
        :nv "C-<up>"      'evil-window-up
        :nv "C-<down>"    'evil-window-down
        :nv "S-<left>"    '+evil/window-move-left
        :nv "S-<right>"   '+evil/window-move-right
        :nv "S-<up>"      '+evil/window-move-up
        :nv "S-<down>"    '+evil/window-move-down
        :nv "C-S-<left>"  'evil-window-move-far-left
        :nv "C-S-<right>" 'evil-window-move-far-right
        :nv "C-S-<up>"    'evil-window-move-very-top
        :nv "C-S-<down>"  'evil-window-move-very-bottom))



;;; evil-goggles
(after! evil-goggles
  (setopt evil-goggles-duration 0.15))



;;; Ligatures
(when (modulep! :ui ligatures)
  (setopt +ligatures-in-modes '(org-mode)
          +ligatures-extras-in-modes '(org-mode)
          +ligatures-extra-symbols
          '(;; org
            :name          "»"
            :src_block     "›"
            :src_block_end "‹"
            :quote         "“"
            :quote_end     "”")))



;; Casual
(use-package! casual
  :bind (:map
         calc-mode-map
         ("C-o" . casual-calc-tmenu)
         :map
         calc-alg-map
         ("C-o" . casual-calc-tmenu))
  :after calc)



;; emacs-rotate.el
(map! :leader
      :after rotate
      "w SPC"         'rotate-layout)



;;; apheleia
(after! apheleia
  (setopt apheleia-remote-algorithm 'remote))



;;; doc-view-mode
(after! doc-view
  (setopt doc-view-resolution 300))



;;; diff-hl
(after! diff-hl
  (setopt diff-hl-side 'right))



;;; git-gutter-fringe
(after! git-gutter-fringe
  (setopt git-gutter-fr:side 'right-fringe))



;;; page-break-lines
(use-package! page-break-lines
  :defer t
  :hook ((emacs-lisp-mode help-mode) . page-break-lines-mode))



;;; browse-url
;; set browse-url so it opens the windows browser when inside wsl
(defvar wsl-flag
  (and (eq system-type 'gnu/linux)
       (not (null (string-match-p "-[Mm]icrosoft"
                                  (shell-command-to-string "uname -r")))))
  "t if current system is WSL else null.")

(after! browse-url
  (when wsl-flag
    (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
          (cmd-args '("/c" "start")))
      (when (file-exists-p cmd-exe)
        (setopt browse-url-generic-program  cmd-exe
                browse-url-generic-args     cmd-args
                browse-url-browser-function 'browse-url-generic)))))



;;; Company
(after! company
  (setopt company-idle-delay 0
          company-minimum-prefix-length 1)

  ;; childframe can sometimes stay open when entering normal mode (esp. in
  ;; python files)
  ;; REVIEW `company-box' should behave; figure out why & remove
  (add-hook! 'evil-normal-state-entry-hook
    (defun +company-abort-h ()
      (when company-candidates
        (company-abort)))))




;;; Corfu
(after! corfu
  (setopt +corfu-want-ret-to-confirm 'both))

(after! corfu-terminal
  ;; always enable so corfu works in the tty for mixed tty/gui sessions
  (corfu-terminal-mode +1))



;;; Pinentry
(use-package! pinentry
  :if (not (featurep :system 'windows))
  :defer t
  :init (pinentry-start))

(after! pinentry
  (defun pinentry-restart ()
    "Restart pinentry service."
    (interactive)
    (pinentry-stop)
    (pinentry-start)))



;;; Spellcheck
(after! ispell
  (setopt ispell-dictionary "en_GB"
          ispell-personal-dictionary "~/.aspell.en.pws"
          langtool-default-language "en-GB"))



;;; Spell-fu
(after! spell-fu
  (setq-hook! 'prog-mode-hook
    spell-fu-faces-include '(tree-sitter-hl-face:comment
                             tree-sitter-hl-face:doc
                             tree-sitter-hl-face:string
                             font-lock-comment-face
                             font-lock-doc-face
                             font-lock-string-face)))



;;; TRAMP
(after! tramp
  ;; set terminal type to "tramp" to allow specific config in shell rc files
  (setopt tramp-terminal-type "tramp")
  ;; root access on remote machines
  (add-to-list 'tramp-default-proxies-alist
               '("^dionysus2$" "^root$" "/ssh:corin@dionysus2:"))
  ;; use remote machine's PATH
  ;; required for e.g. executables managed by home-manager
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))



;;; avy
(after! avy
  (setopt avy-all-windows t
          avy-all-windows-alt 'all-frames))



;;; docker.el
(after! docker
  (setopt docker-run-as-root t))



;;; Flymake
(after! flymake
  (setopt flymake-fringe-indicator-position 'left-fringe)
  ;; ./, are hard to differentiate with underlines
  (custom-set-faces!
    '(flymake-error :background "#512725" :underline nil)
    '(flymake-warning :background "#524629" :underline nil)
    '(flymake-note :background "#1e3b40" :underline nil )))



;;; Flycheck
(after! flycheck
  (setopt flycheck-indication-mode 'left-fringe
          flycheck-checker-error-threshold 10000)
  ;; ./, are hard to differentiate with wavy underlines, so use dotted line
  (custom-set-faces!
    '(flycheck-error :underline (:position 0 :color "#fb4934" :style dots))
    '(flycheck-warning :underline (:position 0 :color "#fabd2f" :style dots))
    '(flycheck-info :underline (:position 0 :color "#83a598" :style dots)))

  ;; Add nix-ts-mode support to statix checker
  (flycheck-add-mode 'statix 'nix-ts-mode))



;;; indent bars
(after! indent-bars
  (add-hook! '+indent-guides-inhibit-functions
    (defun +indent-guides-dired-p ()
      (derived-mode-p 'dired-mode))))



;;; Smartparens
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)



;; electric-pair
(use-package! electric-pair-mode
  :defer t
  :hook (prog-mode . electric-pair-mode))

(defun electric-pair-open-newline-between-pairs-and-indent-psif ()
  "Modified version of electric-pair-open-newline-between-pairs-psif that will
correctly indent the new opening bracket."
  (when (and (if (functionp electric-pair-open-newline-between-pairs)
                 (funcall electric-pair-open-newline-between-pairs)
               electric-pair-open-newline-between-pairs)
             (eq last-command-event ?\n)
             (< (1+ (point-min)) (point) (point-max))
             (eq (save-excursion
                   (skip-chars-backward "\t\s")
                   (char-before (1- (point))))
                 (matching-paren (char-after))))
    (save-excursion (newline "1" t)
                    (indent-according-to-mode))))

(defun electric-pair-inhibit (char)
  (or (electric-pair-conservative-inhibit char)
      (electric-pair-inhibit-if-helps-balance char)))

(after! elec-pair
  (setopt electric-pair-inhibit-predicate #'electric-pair-inhibit
          electric-pair-open-newline-between-pairs t)
  (advice-add 'electric-pair-open-newline-between-pairs-psif :override #'electric-pair-open-newline-between-pairs-and-indent-psif))



;;; info-colors
(use-package! info-colors
  :defer t
  :after info
  :hook (Info-selection . info-colors-fontify-node))



;; iscroll
(use-package! iscroll
  :defer t
  :hook (text-mode . iscroll-mode))



;;; keyfreq
(after! keyfreq
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))



;;; lsp-mode (global)
(after! lsp-mode
  (setopt lsp-enable-indentation t
          lsp-enable-relative-indentation t
          lsp-enable-text-document-color t
          lsp-enable-folding t
          lsp-enable-on-type-formatting t
          lsp-enable-suggest-server-download nil
          lsp-enable-snippet t
          lsp-headerline-breadcrumb-enable t
          lsp-lens-enable nil
          lsp-ui-sideline-enable nil
          lsp-signature-auto-activate '(:on-server-request))

  ;; Use emacs-lsp-booster
  ;; From blahgeek/emacs-lsp-booster README
  (defun lsp-booster--advice-json-parse (old-fn &rest args)
    "Try to parse bytecode instead of json."
    (or
     (when (equal (following-char) ?#)
       (let ((bytecode (read (current-buffer))))
         (when (byte-code-function-p bytecode)
           (funcall bytecode))))
     (apply old-fn args)))
  (advice-add (if (progn (require 'json)
                         (fboundp 'json-parse-buffer))
                  'json-parse-buffer
                'json-read)
              :around
              #'lsp-booster--advice-json-parse)

  (defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
    "Prepend emacs-lsp-booster command to lsp CMD."
    (let ((orig-result (funcall old-fn cmd test?)))
      (if (and (not test?)                             ;; for check lsp-server-present?
               (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
               lsp-use-plists
               (not (functionp 'json-rpc-connection))  ;; native json-rpc
               (executable-find "emacs-lsp-booster"))
          (progn
            (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
              (setcar orig-result command-from-exec-path))
            (message "Using emacs-lsp-booster for %s!" orig-result)
            (append '("emacs-lsp-booster" "--disable-bytecode" "--") orig-result))
        orig-result)))
  (advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command))



;; eglot
(after! eglot
  (add-hook! 'eglot-managed-mode-hook (eglot-inlay-hints-mode -1))
  (add-to-list 'eglot-server-programs
               '(beancount-mode . ("beancount-language-server"))))



;; eglot-booster
(use-package! eglot-booster
  :when (modulep! :tools lsp +eglot)
  :hook (prog-mode . eglot-booster-mode)
  :config (setopt eglot-booster-no-remote-boost t))



;;; Eldoc
(after! eldoc
  (setopt eldoc-echo-area-use-multiline-p nil))



;; Reflow

(use-package! reflow
  :config
  (setopt reflow-column-margin 0))

(after! reflow
  (reflow-mode 1)

  (defun +reflow-fill-paragraph (&optional justify)
    "Use `reflow-paragraph' in prose contexts, otherwise `fill-paragraph'."
    (interactive (list (if current-prefix-arg 'full)))
    (if (reflow--prose-context-p)
        (reflow-paragraph justify)
      (fill-paragraph justify)))
  (global-set-key [remap fill-paragraph] #'+reflow-fill-paragraph)

  (evil-define-operator +reflow-evil-fill (beg end)
    "Like `evil-fill', preferring `reflow-region' in prose contexts."
    :move-point nil
    :type line
    (save-excursion
      (condition-case nil
          (if (save-excursion (goto-char beg) (reflow--prose-context-p))
              (reflow-region beg end)
            (fill-region beg end))
        (error nil))))

  (evil-define-operator +reflow-evil-fill-and-move (beg end)
    "Like `evil-fill-and-move', preferring `reflow-region' in prose contexts."
    :move-point nil
    :type line
    (let ((marker (make-marker)))
      (move-marker marker (1- end))
      (condition-case nil
          (progn
            (if (save-excursion (goto-char beg) (reflow--prose-context-p))
                (reflow-region beg end)
              (fill-region beg end))
            (goto-char marker)
            (evil-first-non-blank))
        (error nil))))

  (evil-define-key '(normal visual motion) 'global
    [remap evil-fill] #'+reflow-evil-fill
    [remap evil-fill-and-move] #'+reflow-evil-fill-and-move))



;;; Text-mode
(add-hook! 'text-mode-hook #'mixed-pitch-mode)



;;; treemacs
(after! treemacs
  (setopt doom-themes-treemacs-theme "doom-colors"))



;;; eshell
(after! em-pred
  ;; add full qualifier from zsh
  (add-to-list 'eshell-predicate-alist
               '(?F . (lambda (file)
                        (and (file-directory-p file)
                             (not (directory-empty-p file)))))))

(after! eshell
  ;; muscle memory compensation
  (set-eshell-alias!
   "vi" "find-file"
   "vim" "find-file"
   "nvim" "find-file"
   "emacs" "find-file")

  ;; from my .zshrc
  (set-eshell-alias!
   "pie" "perl -pi -e"
   "rsync" "rsync -avzhPHA --info=progress2"
   "srsync" "rsync --info=progress2 -avzPhHAe ssh"
   "nfb" "nix-fast-build"
   "nixpkgs-revhead" "nixpkgs-review rev HEAD"
   "pdfopt" "gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=$2 $1")

  ;; grml
  (set-eshell-alias!
   "cdt" "cd ${mktemp -d}; pwd"
   "cl" "cd $1; ls -a"
   "da" "du -sch"
   "insecscp" "scp -o \"StrictHostKeyChecking=no\" -o \"UserKnownHostsFile=/dev/null\""
   "llog" "sudo journalctl"
   "tlog" "sudo journalctl -f"
   "mdstat" "cat /proc/mdstat"
   "mkcd" "mkdir -p $1; cd $1" ;; will not inform if dir already exists
   "rmcdir" "cd ..; *rmdir $- || cd $-" ;; built-in rmdir does not return non-zero
   "j" "jobs -l"
   "llblk" "lsblk -o +LABEL,PARTLABEL,UUID,FSTYPE,SERIAL"

   "dir" "ls -lSrah"
   "l" "ls -l"
   "la" "ls -la"
   "lad" "ls -d .*(/)" ;; shows ./ and ../
   "lh" "ls -hAl"
   "ll" "ls -l"
   "lsa" "ls -a .*(.)"
   "lsbig" "ls -Slh | head -n 11"
   "lsd" "ls -d *(/)"
   "lse" "ls -d *(/^F)"
   "lsl" "ls -ld *(@)"
   "lsnew" "ls -rl | head -n 11"
   "lsnewdir" "ls -rld *(/) | head -n 11"
   "lsold" "ls -rlt | head -n 11"
   "lsolddir" "ls -rltd *(/) | head -n 11"
   "lss" "ls -l *(sSt)"
   "lssmall" "ls -Slhr | head -n 11"
   "lsw" "ls -ld *(RWX)"
   "lsx" "ls -l *(*)")

  ;; functions ported from my .zshrc
  (defun eshell/myip (&optional flag)
    "Print this host's public IP.  FLAG is `-4' (default) or `-6'."
    (string-trim
     (shell-command-to-string
      (format "curl -s %s https://icanhazip.com" (or flag "-4")))))

  (defun eshell/hex (n)
    "Print N as hexadecimal."
    (format "%x" (if (stringp n) (string-to-number n) n)))

  (defun eshell/swap (file1 file2)
    "Swap FILE1 and FILE2 by renaming through a temporary name."
    (let ((tmp (make-temp-name (concat (expand-file-name file1) "."))))
      (rename-file file1 tmp)
      (rename-file file2 file1)
      (rename-file tmp file2)))

  ;; grml's `any'
  (defun eshell/any (term)
    (let ((s (format "%s" (or term ""))))
      (when (string-empty-p s)
        (user-error "Usage: any KEYWORD"))
      (let ((pat (concat "[" (substring s 0 1) "]" (substring s 1))))
        (shell-command-to-string
         (format "ps xauwww | grep -i %s" (shell-quote-argument pat))))))

  ;; grml's `accessed' / `changed' / `modified'
  (defun +eshell--list-by-time (attr-fn days)
    "Print non-hidden files in CWD whose timestamp (per ATTR-FN) is within DAYS days."
    (let ((cutoff (- (float-time) (* (or days 1) 86400))))
      (dolist (f (directory-files default-directory nil "^[^.]"))
        (when-let* ((attrs (file-attributes f))
                    ((> (float-time (funcall attr-fn attrs)) cutoff)))
          (eshell-printn f)))))

  (defun eshell/accessed (&optional days)
    "List files accessed within DAYS days (default 1)."
    (+eshell--list-by-time #'file-attribute-access-time days))

  (defun eshell/changed (&optional days)
    "List files with status changed within DAYS days (default 1)."
    (+eshell--list-by-time #'file-attribute-status-change-time days))

  (defun eshell/modified (&optional days)
    "List files modified within DAYS days (default 1)."
    (+eshell--list-by-time #'file-attribute-modification-time days))

  ;; `rationalise-dot' from zsh for eshell
  (defun +eshell-rationalise-dot ()
    (interactive)
    (if (looking-back "\\(?:^\\|[/ \t|;&]\\)\\.\\."
                      (max (point-min) (- (point) 3)))
        (insert "/..")
      (insert ".")))

  (define-key eshell-mode-map (kbd ".") #'+eshell-rationalise-dot))

(after! em-dirs
  ;; zsh-style AUTO_PUSHD
  (setopt eshell-pushd-dunique t
          eshell-pushd-tohome t
          eshell-last-dir-unique t)

  (defvar +eshell--auto-pushd-inhibit nil
    "When non-nil, suppress `+eshell-auto-pushd-h'.")

  ;; prevent `pushd'/`popd'`'s own dirstack managegement from interfering
  (define-advice eshell/pushd (:around (orig &rest args) +auto-pushd-inhibit)
    (let ((+eshell--auto-pushd-inhibit t)) (apply orig args)))
  (define-advice eshell/popd (:around (orig &rest args) +auto-pushd-inhibit)
    (let ((+eshell--auto-pushd-inhibit t)) (apply orig args)))

  (add-hook! 'eshell-directory-change-hook
    (defun +eshell-auto-pushd-h ()
      "Push the previous directory onto `eshell-dirstack' on every cd."
      (unless +eshell--auto-pushd-inhibit
        (when-let* ((ring eshell-last-dir-ring)
                    ((not (ring-empty-p ring)))
                    (prev (ring-ref ring 0)))
          (unless (and eshell-pushd-dunique (member prev eshell-dirstack))
            (push prev eshell-dirstack))))))

  ;; grmls smart cd: correct `cd <file>' to `cd <file_parent>'
  (define-advice eshell/cd (:around (orig &rest args) +smart-cd)
    (let* ((flat (flatten-tree args))
           (arg (and (= (length flat) 1)
                     (stringp (car flat))
                     ;; skip eshell special forms: `-', `-N', `=foo'
                     (not (string-match-p "\\`\\(-[0-9]*\\|=\\)" (car flat)))
                     (car flat)))
           (parent (and arg
                        (file-regular-p arg)
                        (or (file-name-directory arg) "."))))
      (if parent
          (progn
            (message "Correcting %s to %s" arg parent)
            (funcall orig parent))
        (apply orig args)))))

(after! em-hist
  (setopt eshell-hist-ignoredups t ; HIST_IGNORE_DUPS
          eshell-history-size 50000 ; HISTSIZE
          eshell-input-filter ; HIST_IGNORE_SPACE
          (lambda (input)
            (and (eshell-input-filter-default input)
                 (not (string-match-p "\\`\\s-" input))))))



;;; Magit
(use-package! magit-delta
  :defer t
  :when (modulep! :tools magit)
  :after magit)

(after! magit
  (magit-delta-mode +1)
  (add-hook 'magit-mode-hook (lambda () (indent-bars-mode -1)))
  (setopt git-commit-summary-max-length 72
          magit-delta-delta-args
          ;; need to use the magit-delta feature set defined in my git config as
          ;; line-numbers are not supported inside magit
          '("--24-bit-color" "always"
            "--features" "magit-delta"
            "--color-only")
          magit-diff-visit-prefer-worktree t))



;;; Eat
(use-package! eat
  :defer t
  :hook (eat-mode . mode-line-invisible-mode)
  :init
  ;; Broader than "*eat*" so the rule fires for project-prefixed names too
  ;; (e.g. "*my-project-eat*" from `eat-project').
  (set-popup-rule! "^\\*\\(?:.*-\\)?eat\\*" :size 0.25 :vslot -4 :select t :quit nil :ttl 0)
  :config
  (setopt eat-kill-buffer-on-exit t
          eat-term-scrollback-size 200000)
  (setq-hook! 'eat-mode-hook
    confirm-kill-processes nil
    hscroll-margin 0))

;; integrate eat with eshell whenever eshell loads, regardless of which package
;; gets loaded first
(after! eshell
  (require 'eat)
  (eat-eshell-mode 1)
  (eat-eshell-visual-command-mode 1))

(defvar eat-buffer-name)

(defun +eat/toggle (arg)
  "Toggle an eat popup window in the current workspace.
The terminal cwd starts at the project root. With prefix ARG, kill
and recreate the buffer."
  (interactive "P")
  (let* ((project-root (or (doom-project-root) default-directory))
         (default-directory project-root)
         (persp-name (if (bound-and-true-p persp-mode)
                         (safe-persp-name (get-current-persp))
                       "main"))
         (eat-buffer-name (format "*%s-eat*" persp-name))
         (buffer (get-buffer eat-buffer-name)))
    (setenv "PROOT" project-root)
    (when (and arg buffer)
      (let (confirm-kill-processes)
        (kill-buffer buffer))
      (setq buffer nil))
    (if-let* ((window (and buffer (get-buffer-window buffer))))
        (delete-window window)
      (eat))))

(defun +eat/here (arg)
  "Open eat in the current window, bypassing popup rules.
Cd to the project root by default. With prefix ARG, use the current
`default-directory' instead."
  (interactive "P")
  (let* ((project-root (or (doom-project-root) default-directory))
         (default-directory (if arg default-directory project-root)))
    (setenv "PROOT" project-root)
    (let (display-buffer-alist)
      (eat))))

(map! :leader
      (:prefix "o"
       :desc "Toggle eat popup" "t" #'+eat/toggle
       :desc "Open eat here"    "T" #'+eat/here))



;;; Vterm
;; define commands in vterm that will interact with the enclosing emacs instance
(after! vterm
  (setf (alist-get "woman" vterm-eval-cmds nil nil #'equal)
        '((lambda (topic)
            (woman topic)))
        (alist-get "dired" vterm-eval-cmds nil nil #'equal)
        '((lambda (dir)
            (dired dir)))))



;;; cc-mode (C/C++/Objective-C/Java/COBRA IDL/Pike/AWK)
(after! cc-mode
  (setopt c-default-style "bsd"
          c-basic-offset 4))



;;; Clojure
;; use flycheck-clojure to add eastwood and kibit support
(use-package! flycheck-clojure
  :defer t
  :when (and (modulep! :checkers syntax) (modulep! :lang clojure))
  :after (flycheck clojure-mode)
  :commands (flycheck-clojure-setup))

(after! (flycheck cider)
  (flycheck-clojure-setup)) ; must be run after cider

(after! clj-refactor
  (setopt cljr-warn-on-eval nil))

;; recognise .bb (babashka) files as clojure
(add-to-list 'auto-mode-alist '("\\.bb\\'" . clojure-mode))



;;; LaTeX
(after! tex-mode
  (setopt tex-fontify-script nil ; full-size rendering of (sub|super)scripts
          font-latex-fontify-script nil ; 〃
          LaTeX-indent-level 4
          LaTeX-item-indent -2)

  ;; make fill (gwip/gqip) use LaTeX-fill-region so indents are respected
  (evil-define-operator evil-LaTeX-fill (beg end)
    :move-point nil
    :type line
    (save-excursion
      (condition-case nil
          (LaTeX-fill-region beg end)
        (error nil))))

  (evil-define-operator evil-LaTeX-fill-and-move (beg end)
    :move-point nil
    :type line
    (let ((marker (make-marker)))
      (move-marker marker (1- end))
      (condition-case nil
          (progn
            (LaTeX-fill-region beg end)
            (goto-char marker)
            (evil-first-non-blank))
        (error nil))))

  (evil-define-key 'normal LaTeX-mode-map "gw"
    #'evil-LaTeX-fill)
  (evil-define-key 'normal LaTeX-mode-map "gq"
    #'evil-LaTeX-fill-and-move))



;; typst
(use-package! typst-ts-mode)



;;; Nix
(after! lsp-nix
  (setopt lsp-nix-nil-formatter ["nixfmt"]))

;; Fix statix on nix-ts-mode by explicitly chaining
(after! (lsp-diagnostics flycheck)
  (lsp-diagnostics-flycheck-enable)
  (flycheck-add-next-checker 'lsp 'statix))



;;; org-mode
;; set org-directory _before_ org loads
(setopt org-directory "~/org/")

(after! org
  (use-package! org-inlinetask)
  (use-package! ox-gfm)
  (use-package! ox-rst)
  (use-package! ox-koma-letter)

  (use-package! org-pandoc-import
    :defer t
    :when (modulep! :lang org))
  (add-hook! 'org-mode-hook #'+org-pretty-mode)

  (setopt org-use-property-inheritance t
          org-pretty-entities nil
          org-log-done 'time ; matches behaviour of orgzly
          org-list-allow-alphabetical t
          org-export-in-background nil
          org-latex-pdf-process '("latexmk -f -pdf -%latex -shell-escape -interaction=nonstopmode -output-directory=%o %f")
          org-latex-src-block-backend 'minted
          org-latex-packages-alist '(("cache=false" "minted"))
          org-re-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"
          org-ellipsis " ▼ "
          )

  ;; use LuaLaTeX for inline LaTeX previews so unicode works
  (unless (assq 'luadvisvg org-preview-latex-process-alist)
    (setopt org-preview-latex-process-alist
            (cl-acons 'luaimagemagick
                      '(:programs ("lualatex" "convert")
                        :description "pdf > png (via lualatex)"
                        :message "you need to install the programs: lualatex and imagemagick."
                        :image-input-type "pdf"
                        :image-output-type "png"
                        :image-size-adjust (1.0 . 1.0)
                        :latex-compiler ("lualatex -interaction nonstopmode -output-directory %o %f")
                        :image-converter ("convert -density %D -trim -antialias %f -quality 100 %O"))
                      org-preview-latex-process-alist)
            org-preview-latex-default-process 'luaimagemagick))

  ;; Toggle subtrees with ↹
  (after! evil-org
    (remove-hook 'org-tab-first-hook #'+org-cycle-only-current-subtree-h))

  ;; arrow key equivalents for g(h|j|k|l)
  (map! :after evil-org
        :map evil-org-mode-map
        ;; :nvm "C-<up>"    'outline-backward-same-level
        ;; :nvm "C-<down>"  'outline-forward-same-level)
        :nvm "g <left>"  'org-up-element
        :nvm "g <right>" 'org-down-element
        :nvm "g <up>"    'outline-backward-same-level
        :nvm "g <down>"  'outline-forward-same-level)

  ;; toggle markup characters on hover
  (use-package! org-appear
    :defer t
    :hook (org-mode . org-appear-mode)
    :when (modulep! :lang org)
    :config
    (setopt org-appear-autoemphasis t
            org-appear-autosubmarkers t
            org-appear-autolinks t)
    ;; for proper first-time setup, `org-appear--set-fragments'
    ;; needs to be run after other hooks have acted.
    (run-at-time nil nil #'org-appear--set-fragments))

  ;; toggle LaTeX preview on hover
  (use-package! org-fragtog
    :defer t
    :when (modulep! :lang org)
    :hook (org-mode . org-fragtog-mode))

  ;; sans serif outlines
  (custom-set-faces!
    '(outline-1 :family "Myosevka Aile")
    '(outline-2 :family "Myosevka Aile")
    '(outline-3 :family "Myosevka Aile")
    '(outline-4 :family "Myosevka Aile")
    '(outline-5 :family "Myosevka Aile")
    '(outline-6 :family "Myosevka Aile")
    '(outline-8 :family "Myosevka Aile")
    '(outline-9 :family "Myosevka Aile"))

  ;; add entry to org-smart-quotes-alist for eng-gb
  (after! ox
    (setf (alist-get "en-gb" org-export-smart-quotes-alist nil nil 'string=)
          (alist-get "en" org-export-smart-quotes-alist nil nil 'string=))))



;;; Python
(after! python
  (setopt python-fill-docstring-style 'django))

(after! (python lsp-mode)
  (setopt lsp-pylsp-plugins-ruff-enabled t
          lsp-pyright-langserver-command "basedpyright"
          lsp-pyright-disable-organize-imports t))



;;; Rust
(after! rust-mode
  (setq-hook! 'rust-mode-hook
    +format-with-lsp nil)
  (after! lsp-mode
    (setopt lsp-rust-analyzer-cargo-watch-command "clippy"
            lsp-rust-analyzer-completion-add-call-parenthesis nil
            lsp-rust-analyzer-completion-add-call-argument-snippets nil)))



;;; sh
(setopt sh-basic-offset 2)
(setq-hook! 'sh-mode-hook
  evil-shift-width sh-basic-offset
  tab-width sh-basic-offset)
(after! (apheleia)
  (setf (alist-get 'sh-mode apheleia-mode-alist) 'shfmt))



;;; Projectile
(when (modulep! :emacs dired +dirvish)
  (defun projectile-dirvish ()
    (interactive)
    (dirvish (projectile-project-root)))

  (map! :leader
        "p -" 'projectile-dired
        "p /" 'projectile-dirvish))

(after! (projectile)
  (setopt projectile-project-search-path '(("~/code/" . 2)))

  (defun +projectile-invalidate-cache-maybe (&rest _)
    (when (projectile-project-p)
      (projectile-invalidate-cache nil)))

  ;; Invalidate cache after git operations that change files
  (dolist (hook '(magit-post-checkout-hook
                  magit-post-merge-hook
                  magit-post-rebase-hook))
    (add-hook hook #'+projectile-invalidate-cache-maybe))

  (dolist (fn '(dired-do-rename
                dired-do-delete
                dired-do-copy
                dired-create-directory
                doom/delete-this-file
                doom/move-this-file
                magit-pull
                magit-stash-both
                magit-stash-worktree
                magit-stash-index
                magit-stash-keep-index
                magit-stash-apply
                magit-stash-pop))
    (advice-add fn :after #'+projectile-invalidate-cache-maybe)))



;;; treesit
(after! (treesit)
  (setopt treesit-font-lock-level 4))



;;; YAML
(after! (yaml-ts-mode)
  (derived-mode-set-parent 'yaml-ts-mode 'prog-mode)
  (add-hook 'yaml-ts-mode-hook
            (lambda ()
              (when (bound-and-true-p mixed-pitch-mode)
                (mixed-pitch-mode -1)))
            t))


