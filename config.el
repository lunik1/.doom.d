;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-



;;; Global
(setf display-line-numbers-type 'relative
      x-stretch-cursor t
      truncate-string-ellipsis "…"
      scroll-margin 5
      hscroll-margin 10
      display-line-numbers-type 'relative
      tab-width 4
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



;;; DOOM
(setf +doom-dashboard-banner-dir "~/.doom.d/"
      +doom-dashboard-banner-file "tem.png"
      +doom-dashboard-banner-padding '(0 . 2)
      doom-font (font-spec :family "Myosevka" :size 14)
      doom-unicode-font (font-spec :family "Julia Mono")
      doom-variable-pitch-font (font-spec :family "Myosevka Etoile" :size 14)
      doom-serif-font (font-spec :family "Myosevka Etoile" :size 14)
      doom-theme 'doom-gruvbox
      doom-themes-enable-bold t
      doom-themes-enable-italic t)

(after! doom-modeline
  (setf doom-modeline-unicode-fallback t))



;;; Evil
(after! evil
  (setf evil-emacs-state-cursor '(bar +evil-emacs-cursor-fn))

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
  (require 'evil-textobj-anyblock)
  (evil-define-text-object my-evil-textobj-anyblock-inner-quote
    (count &optional beg end type)
    "Select the closest outer quote."
    (let ((evil-textobj-anyblock-blocks
           '(("'" . "'")
             ("\"" . "\"")
             ("«" . "»")
             ("`" . "`")
             ("“" . "”"))))
      (evil-textobj-anyblock--make-textobj beg end type count nil)))

  (evil-define-text-object my-evil-textobj-anyblock-a-quote
    (count &optional beg end type)
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
  (setf evil-digraphs-table-user '(((?* ?e) . ?ϵ)
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



;;; Ligatures
(when (modulep! :ui ligatures)
  (setf +ligatures-in-modes '(org-mode)
        +ligatures-extras-in-modes '(org-mode)
        +ligatures-extra-symbols
        '(;; org
          :name          "»"
          :src_block     "›"
          :src_block_end "‹"
          :quote         "“"
          :quote_end     "”")))



;; emacs-rotate.el
(map! :leader
      :after rotate
      "w SPC"         'rotate-layout)



;;; doc-view-mode
(after! doc-view
  (setf doc-view-resolution 300))



;;; git-gutter
(after! git-gutter-fringe
  (setf git-gutter-fr:side 'right-fringe))



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
        (setf browse-url-generic-program  cmd-exe
              browse-url-generic-args     cmd-args
              browse-url-browser-function 'browse-url-generic)))))



;;; Company
(after! company
  (setf company-idle-delay 0
        company-minimum-prefix-length 2)

  ;; childframe can sometimes stay open when entering normal mode (esp. in
  ;; python files)
  ;; REVIEW `company-box' should behave; figure out why & remove
  (add-hook! 'evil-normal-state-entry-hook
    (defun +company-abort-h ()
      (when company-candidates
        (company-abort)))))



;;; Pinentry
(use-package! pinentry
  :defer t
  :init (pinentry-start))



;;; Spellcheck
(after! ispell
  (setf ispell-dictionary "en_GB"
        ispell-personal-dictionary "~/.aspell.en.pws"
        langtool-default-language "en-GB"))



;;; TRAMP
(after! tramp
  ;; set terminal type to "tramp" to allow specific config in shell rc files
  (setf tramp-terminal-type "tramp")
  ;; root access on remote machines
  (add-to-list 'tramp-default-proxies-alist
               '("^dionysus2$" "^root$" "/ssh:corin@dionysus2:"))
  ;; use remote machine's PATH
  ;; required for e.g. executables managed by home-manager
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))



;;; avy
(after! avy
  (setf avy-all-windows t
        avy-all-windows-alt 'all-frames))



;;; docker.el
(after! docker
  (setf docker-run-as-root t))



;;; Flycheck
(after! flycheck
  (setf flycheck-indication-mode 'left-fringe))



;;; info-colors
(use-package! info-colors
  :defer t
  :after Info-mode-hook
  :hook (Info-selection . info-colors-fontify-node))



;;; keyfreq
(after! keyfreq
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))



;;; eglot
(after! eglot
  (add-hook! 'eglot-managed-mode-hook (eglot-inlay-hints-mode -1)))



(after! eldoc
  (setf eldoc-echo-area-use-multiline-p nil))



;;; Text-mode
(add-hook! 'text-mode-hook #'mixed-pitch-mode)



;;; ranger
(after! ranger
  (add-hook 'ranger-mode-hook 'all-the-icons-dired-mode))

(when (modulep! :emacs dired +ranger)
  (map! :leader
        "o _" 'ranger))



;;; treemacs
(after! treemacs
  (setf doom-themes-treemacs-theme "doom-colors"))



;;; eshell
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
   "rsync" "rsync -avzhPHA --checksum-choice=xxh3 --compress-choice=lz4 --info=progress2"
   "srsync" "rsync --checksum-choice=xxh3 --compress-choice=zstd --info=progress2 -avzPhHAe ssh")

  ;; grml
  (set-eshell-alias!
   "cdt" "cd ${mktemp -d}; pwd"
   "da" "du -sch"
   "dir" "ls -lSrah"
   "insecscp" "scp -o \"StrictHostKeyChecking=no\" -o \"UserKnownHostsFile=/dev/null\""
   "l" "ls -l"
   "la" "ls -la"
   "lh" "ls -hAl"
   "ll" "ls -l"
   "llog" "sudo journalctl -f"
   "llog" "sudo journalctl"
   "mkcd" "mkdir -p $1; cd $1" ;; will not inform if dir already exists
   "rmcdir" "cd ..; *rmdir $- || cd $-") ;; built-in rmdir does not return non-zero

  (defun disable-company-remote ()
    (when (and (fboundp 'company-mode)
               (file-remote-p default-directory))
      (company-mode -1)))

  ;; Only works if we open eshell in a remote dir (e.g. via SPC o t), not if we ssh
  (add-hook! 'eshell-mode-hook 'disable-company-remote))



;;; Magit
(use-package! magit-delta
  :defer t
  :when (modulep! :tools magit)
  :after magit)

(after! magit
  (magit-delta-mode +1)
  (setf magit-delta-delta-args
        ;; need to use the magit-delta feature set defined in my git config as
        ;; line-numbers are not supported inside magit
        '("--24-bit-color" "always"
          "--features" "magit-delta"
          "--color-only")))



;;; Vterm
;; define commands in vterm that will interact with the enclosing emacs instance
(after! vterm
  (setf (alist-get "woman" vterm-eval-cmds nil nil #'equal)
        '((lambda (topic)
            (woman topic)))
        (alist-get "ranger" vterm-eval-cmds nil nil #'equal)
        '((lambda (dir)
            (ranger dir)))
        (alist-get "dired" vterm-eval-cmds nil nil #'equal)
        '((lambda (dir)
            (dired dir)))))



;;; Beancount
(after! (beancount format-all)
  (set-formatter! 'bean-format "bean-format" :modes 'beancount-mode))



;;; cc-mode (C/C++/Objective-C/Java/COBRA IDL/Pike/AWK)
(after! cc-mode
  (setf c-default-style "bsd"
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
  (setf cljr-warn-on-eval nil))

;; prefer zprint over clojure-lsp's formatter
(after! (clojure-mode format-all)
  (set-formatter! 'zprint '("zprint" "{:search-config? true}")
    :modes '(clojure-mode)))
(after! (clojure-mode eglot)
  (setq-hook! 'clojure-mode-hook +format-with-lsp nil))



;;; LaTeX
(after! tex-mode
  (setf tex-fontify-script nil ; full-size rendering of (sub|super)scripts
        font-latex-fontify-script nil ; 〃
        LaTeX-indent-level 4
        LaTeX-item-indent -2)

  (after! (format-all)
    (set-formatter! 'latexindent "latexindent -l"))

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



;;; Nix
;; HACK use nixpkgs-fmt in nix-mode by setting the nixfmt bin to nixpkgs-fmt
(after! nix-format
  (setf nix-nixfmt-bin "nixpkgs-fmt"))



;;; org-mode
;; set org-directory _before_ org loads
(setf org-directory "~/org/")

(after! org
  (require 'org-inlinetask)
  (require 'ox-gfm nil t)
  (require 'ox-rst)
  (require 'ox-koma-letter)

  (use-package! org-pandoc-import
    :defer t
    :when (modulep! :lang org))
  (add-hook! 'org-mode-hook #'+org-pretty-mode)

  (setf org-use-property-inheritance t
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
    (setf org-preview-latex-process-alist
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
    (setf org-appear-autoemphasis t
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
(after! (python eglot)
  ;; prefer black over lsp's formatter
  (setq-hook! 'python-mode-hook +format-with-lsp nil))



;;; Rust
(after! rust-mode
  (setq-hook! 'rust-mode-hook +format-with-lsp nil)
  (setf lsp-rust-analyzer-cargo-watch-command "clippy"))



;;; sh
(setf sh-basic-offset 2)
(add-hook! 'sh-mode-hook
  (setq-local evil-shift-width sh-basic-offset
              tab-width sh-basic-offset))

;; shfmt: use spaces
(after! (format-all)
  (set-formatter! 'shfmt "shfmt -i 2"))



;;; TOML
;;; format with taplo
(after! (format-all)
  (set-formatter! 'taplo "taplo fmt -" :modes 'conf-toml-mode))



;;; Projectile
(when (modulep! :emacs dired)
  (defun projectile-ranger ()
    (interactive)
    (ranger (projectile-project-root)))

  (map! :leader
        "p -" 'projectile-dired)
  (map! :leader
        :when (modulep! :emacs dired +ranger)
        "p _" 'projectile-ranger))



