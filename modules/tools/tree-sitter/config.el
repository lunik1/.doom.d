;;; tools/tree-sitter/config.el -*- lexical-binding: t; -*-

;; Does deferring loading to prog-mode-hook work ?
(use-package! tree-sitter-langs)

(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
