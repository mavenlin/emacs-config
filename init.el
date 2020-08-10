;; list the repositories containing them
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ;; ("marmalade" . "http://marmalade-repo.org/packages/")
			 ))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; activate all the packages (in particular autoloads)
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; install the missing packages
(dolist (package package-selected-packages)
  (unless (package-installed-p package)
    (package-install package)))


;; emacs default browser
(setq browse-url-browser-function 'browse-url-chrome)
(setq markdown-command "pandoc --from markdown -t html5 --mathjax='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-MML-AM_CHTML' --highlight-style pygments")
(setq markdown-enable-math t)
(setq markdown-preview-javascript (list "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-MML-AM_CHTML"))
(setq markdown-preview-stylesheets (list "http://thomasf.github.io/solarized-css/solarized-light.min.css"))

(set-default-font "inconsolata 12")

(load "~/.emacs.d/helm.el")


(global-set-key (kbd "M-n") 'mc/mark-next-like-this)
(global-set-key (kbd "M-N") 'mc/mark-next-word-like-this)

(global-set-key (kbd "C-x g") 'magit-status)
;; (global-set-key (kbd "M-[") 'mc/mark-previous-word-like-this)
;; (global-set-key (kbd "C-c w") 'mc/mark-all-words-like-this)
;;

(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cc\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cxx\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cuh\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.def\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.param\\'" . sh-mode))

(load-theme 'zenburn t)

(setq TeX-PDF-mode t)
;; Turn on RefTeX for AUCTeX, http://www.gnu.org/s/auctex/manual/reftex/reftex_5.html
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; Make RefTeX interact with AUCTeX, http://www.gnu.org/s/auctex/manual/reftex/AUCTeX_002dRefTeX-Interface.html
(setq reftex-plug-into-AUCTeX t)
(setq TeX-parse-self t) ; Enable parse on load.
(setq TeX-auto-save t) ; Enable parse on save.

;; remove the trailing white spaces when emacs saves a buffer
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; remove the emacs startup page
(setq inhibit-startup-message t)

;; require the google c/c++ code style
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;; define cpplint function to check the code style
(defun cpplint ()
  "check source code format according to Google Style Guide"
  (interactive)
  (compilation-start (concat "python ~/.emacs.d/google/cpplint.py " (buffer-file-name))))

;; enforce the line length to be 80
;; (require 'column-enforce-mode)
;; (add-hook 'c-mode-common-hook 'column-enforce-mode)
(add-hook 'c-mode-common-hook 'fci-mode)
(add-hook 'python-mode-hook 'fci-mode)
(setq fci-rule-column 80)
(setq fci-rule-color "brightblack")
(setq fci-rule-width 1)

;; (require 'smart-tab)
(add-hook 'c-mode-common-hook 'smart-tab-mode)
(add-hook 'lua-mode-hook 'smart-tab-mode)
(add-hook 'latex-mode-common-hook 'smart-tab-mode)
(add-hook 'python-mode-hook 'smart-tab-mode)

;; load protobuf
;; (require 'protobuf-mode)
;; (add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))

;; markdown mode
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs)
  )

(global-unset-key (kbd "C-z"))

;; backup dir
(setq backup-directory-alist '(("." . "/tmp/linmin/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )

(global-set-key (kbd "S-<up>") 'windmove-up)
(global-set-key (kbd "S-<down>") 'windmove-down)
(global-set-key (kbd "S-<right>") 'windmove-right)
(global-set-key (kbd "S-<left>") 'windmove-left)

;; ibuffer mode
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

;; powerline
(require 'powerline)
(load "~/.emacs.d/powerline.el")
(powerline-my-theme)

;; projectile
(projectile-global-mode)

;; c++11
(add-hook
 'c++-mode-hook
 '(lambda()
    ;; We could place some regexes into `c-mode-common-hook', but note that their evaluation order
    ;; matters.
    (font-lock-add-keywords
     nil '(;;  new C++11 keywords
           ("\\<\\(alignof\\|alignas\\|constexpr\\|decltype\\|noexcept\\|nullptr\\|static_assert\\|thread_local\\|override\\|final\\)\\>" . font-lock-keyword-face)
           ("\\<\\(char16_t\\|char32_t\\)\\>" . font-lock-keyword-face)
           ;; integer/float/scientific numbers
           ("\\<[\\-+]*[0-9]*\\.?[0-9]+\\([ulUL]+\\|[eE][\\-+]?[0-9]+\\)?\\>" . font-lock-constant-face)
           ))
    ) t)

;; disable menu
(menu-bar-mode -1)

;; show-paren-mode
(show-paren-mode 1)

;; elpy
;; (package-initialize)
(elpy-enable)

;; save history
(setq history-length t)
(savehist-mode 1)
(setq history-delete-duplicates t)
(setq savehist-max-history-length 100000)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

(require 'visual-regexp-steroids)
(global-set-key (kbd "M-%") 'vr/query-replace)

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/snippets")
(require 'yasnippet)
(yas-global-mode 1)

;; ace-window
(global-set-key (kbd "M-o") 'ace-window)
(setq aw-dispatch-always t)

(load "~/.emacs.d/elfeed.el")

;; ace-jump-mode
(autoload 'ace-jump-mode "ace-jump-mode" "Emacs quick move minor mode" t)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
