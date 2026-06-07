# emacs.nix
#
# REQUIRES: emacs-overlay in your flake inputs + applied to nixpkgs.overlays
# at the top level (not in this file):
#
#   emacs-overlay.url = "github:nix-community/emacs-overlay";
#   nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];

{ pkgs, inputs, config, lib, ... }:
{
  programs.emacs = {
    enable  = true;
    package = pkgs.emacs-pgtk; # Wayland native + native compilation

    extraPackages = epkgs: with epkgs; [
      evil
      evil-collection
      which-key
      helpful
      vertico
      orderless
      marginalia
      consult
      corfu
      magit
      vterm
      org-modern
      olivetti
      org-roam
      nix-mode
      (treesit-grammars.with-grammars (g: with g; [
        tree-sitter-nix
        tree-sitter-go
        tree-sitter-python
        tree-sitter-lua
        tree-sitter-bash
        tree-sitter-json
        tree-sitter-yaml
        tree-sitter-toml
      ]))
    ];

    extraConfig = ''
      ;; Packages are installed by Nix.
      ;; use-package is used only for configuration and lazy loading.
      ;; Never use :ensure t here.

      ;; ================================================================
      ;; PERFORMANCE
      ;; ================================================================

      ;; Raise GC threshold during startup to avoid pauses while loading,
      ;; then lower it back to a reasonable runtime value.
      (setq gc-cons-threshold (* 128 1024 1024))
      (add-hook 'emacs-startup-hook
                (lambda () (setq gc-cons-threshold (* 8 1024 1024))))

      ;; ================================================================
      ;; CORE UI
      ;; ================================================================

      (tool-bar-mode   -1)  ; no toolbar
      (menu-bar-mode   -1)  ; no menu bar
      (scroll-bar-mode -1)  ; no scroll bar
      (setq inhibit-startup-message t)

      (column-number-mode  1)  ; show column in mode line
      (global-hl-line-mode 1)  ; highlight current line
      (show-paren-mode     1)  ; highlight matching parens
      (delete-selection-mode 1) ; typing over a selection replaces it

      ;; Relative line numbers in code and text buffers
      (setq display-line-numbers-type 'relative)
      (add-hook 'prog-mode-hook #'display-line-numbers-mode)
      (add-hook 'text-mode-hook #'display-line-numbers-mode)

      ;; Spaces not tabs, 2-space indent
      (setq-default indent-tabs-mode nil)
      (setq-default tab-width 2)

      (setq sentence-end-double-space nil)
      (setq vc-follow-symlinks t)

      ;; Open splits to the right and below (like nvim splitright/splitbelow)
      (setq split-height-threshold nil
            split-width-threshold  80)

      ;; Keep backup and auto-save files out of working directories
      (setq backup-directory-alist
            `(("." . ,(expand-file-name "backups/" user-emacs-directory))))
      (setq auto-save-file-name-transforms
            `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t)))

      ;; Track recently opened files — needed for consult-recent-file
      (recentf-mode 1)

      ;; Persist minibuffer history across sessions — helps vertico
      (savehist-mode 1)

      ;; ================================================================
      ;; EVIL — vim modal editing
      ;; ================================================================

      ;; These must be set before evil loads
      (setq evil-want-integration t)
      (setq evil-want-keybinding nil) ; evil-collection handles other buffers

      (use-package evil
        :init
        ;; Use Emacs 28+'s native undo/redo (C-/ undo, C-? redo)
        (setq evil-undo-system 'undo-redo)
        :config
        (evil-mode 1)
        ;; K = hover docs (like nvim's LSP hover)
        (evil-define-key 'normal 'global (kbd "K")  #'eldoc-doc-buffer)
        ;; gd / gr via xref, which eglot integrates with automatically
        (evil-define-key 'normal 'global (kbd "gd") #'xref-find-definitions)
        (evil-define-key 'normal 'global (kbd "gr") #'xref-find-references))

      ;; evil-collection makes evil keybinds work in magit, vterm,
      ;; help buffers, dired, etc. Without this those use Emacs bindings.
      (use-package evil-collection
        :demand t
        :after evil
        :config
        (evil-collection-init))

      ;; ================================================================
      ;; SPC LEADER KEY
      ;; ================================================================

      ;; Plain keymap approach — no general.el, no macro timing issues.
      ;; which-key reads the keymap automatically and shows available bindings.

      ;; One keymap per group
      (defvar my/leader-map   (make-sparse-keymap))
      (defvar my/find-map     (make-sparse-keymap))
      (defvar my/buffer-map   (make-sparse-keymap))
      (defvar my/git-map      (make-sparse-keymap))
      (defvar my/lsp-map      (make-sparse-keymap))
      (defvar my/notes-map    (make-sparse-keymap))
      (defvar my/toggle-map   (make-sparse-keymap))
      (defvar my/help-map     (make-sparse-keymap))

      ;; Bind SPC to the leader map in normal, visual, and motion states.
      ;; with-eval-after-load fires immediately here since evil is already loaded.
      (with-eval-after-load 'evil
        (evil-define-key '(normal visual motion) 'global
          (kbd "SPC") my/leader-map))

      ;; ── Top-level leader bindings ────────────────────────────────
      (define-key my/leader-map (kbd "SPC") #'execute-extended-command)
      (define-key my/leader-map (kbd "f")   my/find-map)
      (define-key my/leader-map (kbd "b")   my/buffer-map)
      (define-key my/leader-map (kbd "g")   my/git-map)
      (define-key my/leader-map (kbd "l")   my/lsp-map)
      (define-key my/leader-map (kbd "n")   my/notes-map)
      (define-key my/leader-map (kbd "t")   my/toggle-map)
      (define-key my/leader-map (kbd "h")   my/help-map)

      ;; ── Find / File (SPC f) ──────────────────────────────────────
      (define-key my/find-map (kbd "f") #'consult-find)
      (define-key my/find-map (kbd "g") #'consult-ripgrep)
      (define-key my/find-map (kbd "b") #'consult-buffer)
      (define-key my/find-map (kbd "r") #'consult-recent-file)
      (define-key my/find-map (kbd "h") #'consult-info)
      (define-key my/find-map (kbd "s") #'save-buffer)

      ;; ── Buffer (SPC b) ───────────────────────────────────────────
      (define-key my/buffer-map (kbd "d") #'kill-this-buffer)
      (define-key my/buffer-map (kbd "n") #'next-buffer)
      (define-key my/buffer-map (kbd "p") #'previous-buffer)

      ;; ── Git (SPC g) ──────────────────────────────────────────────
      (define-key my/git-map (kbd "g") #'magit-status)
      (define-key my/git-map (kbd "l") #'magit-log-current)

      ;; ── LSP (SPC l) ──────────────────────────────────────────────
      ;; eglot integrates with xref and flymake automatically,
      ;; so these built-in commands gain LSP powers when eglot is active.
      (define-key my/lsp-map (kbd "d") #'xref-find-definitions)
      (define-key my/lsp-map (kbd "D") #'xref-find-references)
      (define-key my/lsp-map (kbd "a") #'eglot-code-actions)
      (define-key my/lsp-map (kbd "f") #'eglot-format-buffer)
      (define-key my/lsp-map (kbd "n") #'eglot-rename)
      (define-key my/lsp-map (kbd "x") #'flymake-show-buffer-diagnostics)
      (define-key my/lsp-map (kbd "h") #'eldoc-doc-buffer)

      ;; ── Notes / Org (SPC n) ──────────────────────────────────────
      (define-key my/notes-map (kbd "f") #'org-roam-node-find)
      (define-key my/notes-map (kbd "i") #'org-roam-node-insert)
      (define-key my/notes-map (kbd "b") #'org-roam-buffer-toggle)
      (define-key my/notes-map (kbd "a") #'org-agenda)
      (define-key my/notes-map (kbd "c") #'org-capture)

      ;; ── Toggle (SPC t) ───────────────────────────────────────────
      (define-key my/toggle-map (kbd "t") #'vterm)
      (define-key my/toggle-map (kbd "o") #'olivetti-mode)
      (define-key my/toggle-map (kbd "l") #'display-line-numbers-mode)

      ;; ── Help (SPC h) ─────────────────────────────────────────────
      (define-key my/help-map (kbd "f") #'helpful-callable)
      (define-key my/help-map (kbd "v") #'helpful-variable)
      (define-key my/help-map (kbd "k") #'helpful-key)
      (define-key my/help-map (kbd "m") #'describe-mode)

      ;; ── which-key group labels ───────────────────────────────────
      ;; Add human-readable names for each prefix group.
      ;; which-key reads the keymaps automatically for individual bindings;
      ;; this just adds the group name shown when you press the prefix letter.
      (with-eval-after-load 'which-key
        (which-key-add-keymap-based-replacements my/leader-map
          "f" "Find/File"
          "b" "Buffer"
          "g" "Git"
          "l" "LSP"
          "n" "Notes/Org"
          "t" "Toggle"
          "h" "Help"))

      ;; ================================================================
      ;; WHICH-KEY
      ;; ================================================================

      ;; Shows available keybindings after pressing a prefix.
      ;; Press SPC and wait — you'll see all your leader bindings.
      (use-package which-key
        :config
        (which-key-mode 1)
        (setq which-key-idle-delay 0.3))

      ;; ================================================================
      ;; HELPFUL
      ;; ================================================================

      ;; Replaces built-in describe-* with richer output:
      ;; source code, related functions, formatted docstrings.
      (use-package helpful
        :commands (helpful-callable helpful-variable helpful-key))

      ;; ================================================================
      ;; MINIBUFFER COMPLETION STACK
      ;; ================================================================

      ;; vertico: vertical completion list for M-x, find-file, etc.
      (use-package vertico
        :config
        (vertico-mode 1))

      ;; orderless: type parts in any order to filter candidates.
      ;; e.g. "buf del" matches "kill-this-buffer"
      (use-package orderless
        :config
        (setq completion-styles '(orderless basic)
              completion-category-overrides
              '((file (styles basic partial-completion)))))

      ;; marginalia: annotations next to completion candidates
      ;; e.g. docstring shown next to function names in M-x
      (use-package marginalia
        :config
        (marginalia-mode 1))

      ;; consult: enhanced find-file, grep, buffer-switching, etc.
      ;; Lazy loaded — only pulls in when you call one of these commands.
      (use-package consult
        :commands (consult-find consult-ripgrep consult-buffer
                   consult-recent-file consult-info))

      ;; ================================================================
      ;; CORFU — in-buffer completion popup
      ;; ================================================================

      ;; Shows completions as you type. Uses Emacs's built-in completion
      ;; system so it works with eglot, elisp, file paths, etc. automatically.
      (use-package corfu
        :config
        (global-corfu-mode 1)
        (setq corfu-auto        t
              corfu-auto-delay  0.2
              corfu-auto-prefix 2))

      ;; ================================================================
      ;; TREESITTER
      ;; ================================================================

      ;; Emacs 29 has built-in treesitter. Grammars were installed via Nix.
      ;; This remaps traditional modes to their treesitter equivalents.
      (setq major-mode-remap-alist
            '((python-mode . python-ts-mode)
              (go-mode     . go-ts-mode)
              (bash-mode   . bash-ts-mode)
              (json-mode   . json-ts-mode)
              (yaml-mode   . yaml-ts-mode)))

      ;; ================================================================
      ;; EGLOT — LSP client (built into Emacs 29)
      ;; ================================================================

      ;; Connects to language servers for completions, diagnostics,
      ;; go-to-definition, etc. Servers must be in your PATH —
      ;; install them in your Nix system/home config, not here.
      ;; e.g. home.packages = [ pkgs.gopls pkgs.nixd pkgs.python3Packages.python-lsp-server ];
      (use-package eglot
        :hook
        ((go-ts-mode     . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (nix-mode       . eglot-ensure))
        :config
        (setq eglot-events-buffer-size 0) ; don't log every LSP event
        (setq eglot-autoshutdown t))      ; shut down server when done with project

      ;; ================================================================
      ;; MAGIT
      ;; ================================================================

      ;; The best git interface in any editor.
      ;; SPC g g to open. Press ? inside magit for its own help.
      (use-package magit
        :commands (magit-status magit-log-current))

      ;; ================================================================
      ;; VTERM
      ;; ================================================================

      ;; Real terminal emulator inside Emacs via a C library.
      ;; Handles full terminal programs correctly (htop, vim inside emacs, etc.)
      ;; SPC t t to open.
      (use-package vterm
        :commands vterm)

      ;; ================================================================
      ;; ORG MODE
      ;; ================================================================

      (use-package org
        :hook (org-mode . olivetti-mode)
        :config
        ;; Where your org files live. Change this to wherever you want.
        (setq org-directory "~/org")
        (setq org-default-notes-file (concat org-directory "/inbox.org"))

        ;; org-babel: run code blocks directly in org files.
        ;; Write a #+begin_src python block and run it with C-c C-c.
        (org-babel-do-load-languages
         'org-babel-load-languages
         '((python     . t)
           (shell      . t)
           (emacs-lisp . t)))

        (setq org-confirm-babel-evaluate nil) ; don't ask before running code
        (setq org-src-fontify-natively  t)   ; syntax highlight src blocks
        (setq org-src-tab-acts-natively t)   ; tab works correctly in src blocks
        (setq org-hide-emphasis-markers t))  ; hide *bold* markers, show result

      ;; org-modern: nicer bullets, checkboxes, and table lines
      (use-package org-modern
        :hook (org-mode . org-modern-mode))

      ;; olivetti: centers and narrows the buffer for writing
      (use-package olivetti
        :commands olivetti-mode
        :config
        (setq olivetti-body-width 100))

      ;; org-roam: linked notes built on org + sqlite.
      ;; SPC n f to find/create a note, SPC n i to insert a link.
      ;; You don't need to use this right away — it's here when you want it.
      (use-package org-roam
        :commands (org-roam-node-find org-roam-node-insert org-roam-buffer-toggle)
        :config
        (setq org-roam-directory (expand-file-name "roam" org-directory))
        (org-roam-db-autosync-mode))
    '';
  };

  # Emacs daemon: starts once at login, clients connect instantly.
  # Use `emacsclient -c` to open a new frame without cold-starting.
  services.emacs = {
    enable  = true;
    package = config.programs.emacs.finalPackage;
    client.enable = true; # sets emacsclient as $EDITOR, adds desktop entries
  };
}
