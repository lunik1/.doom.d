;; -*- no-byte-compile: t; -*-
;;; tools/tree-sitter/packages.el

(package! tsc :recipe (:host github
                       :repo "ubolonton/emacs-tree-sitter"
                       :files ("core/*.el")))

(package! tree-sitter :recipe (:host github
                               :repo "ubolonton/emacs-tree-sitter"
                               :files ("lisp/*.el")))

(package! tree-sitter-langs :recipe (:host github
                                     :repo "ubolonton/emacs-tree-sitter"
                                     :files ("langs/*.el" "langs/queries")))
