;; list the repositories containing them
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

;; activate all the packages (in particular autoloads)
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))


(set-default-font "inconsolata 12")

(add-to-list 'load-path "~/.emacs.d/google")
(add-to-list 'load-path "~/.emacs.d/protobuf")

;; helm mode
(require 'helm)
(require 'helm-config)
(require 'helm-themes)

(helm-mode 1)
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t)
(define-key minibuffer-local-map (kbd "C-c C-l") 'helm-minibuffer-history)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match t)

(require 'helm-gtags)
;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)
(setq
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

;; ;; auto-complete
;; (setq ac-delay 0.1)
;; (ac-config-default)
;; (defun ac-c-init ()
;;   (require 'auto-complete-c-headers)
;;   (add-to-list 'ac-sources 'ac-source-c-headers)
;;   ;(require 'auto-complete-clang)
;;   ;(add-to-list 'ac-sources 'ac-source-clang)
;; )
;; (add-hook 'c++-mode-hook 'ac-c-init)
;; (add-hook 'c-mode-hook 'ac-c-init)


(global-set-key (kbd "M-n") 'mc/mark-next-like-this)
(global-set-key (kbd "M-N") 'mc/mark-next-word-like-this)
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

;; (load-theme 'tango-dark)
(load-theme 'zenburn t)
;; (load-theme 'spacegray t)
;; (load-theme 'material t)

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
(require 'protobuf-mode)
(add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))

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
(powerline-default-theme)

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

;; elfeed for arxiv

(require 'elfeed-org)
(elfeed-org)
(setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org"))
(global-set-key (kbd "C-x w") 'elfeed)

(defun elfeed-search-filter-star () (interactive)
       (funcall 'elfeed-search-set-filter "-hide +*"))
(defun elfeed-search-filter-all () (interactive)
       (funcall 'elfeed-search-set-filter "@7-days-ago -hide -updated"))
(defun elfeed-search-filter-force-all () (interactive)
       (funcall 'elfeed-search-set-filter "-hide"))
(defun elfeed-search-filter-unread () (interactive)
       (funcall 'elfeed-search-set-filter "@7-days-ago -hide +unread -updated"))
(defun elfeed-search-filter-one-day () (interactive)
       (funcall 'elfeed-search-set-filter "@1-days-ago -hide -updated"))
(define-key elfeed-search-mode-map (kbd "*") 'elfeed-search-filter-star)
(define-key elfeed-search-mode-map (kbd "a") 'elfeed-search-filter-all)
(define-key elfeed-search-mode-map (kbd "A") 'elfeed-search-filter-force-all)
(define-key elfeed-search-mode-map (kbd "u") 'elfeed-search-filter-unread)
(define-key elfeed-search-mode-map (kbd "1") 'elfeed-search-filter-one-day)

(defun elfeed-show-open-arxiv-pdf (&optional use-generic-p)
  (interactive "P")
  (let ((link (elfeed-entry-link elfeed-show-entry)))
    (let ((link (replace-regexp-in-string "/abs/" "/pdf/" link)))
      (when link
	(message "Sent to browser: %s" link)
	(if use-generic-p
            (browse-url-generic link)
          (browse-url link))))))
(define-key elfeed-show-mode-map (kbd "B") 'elfeed-show-open-arxiv-pdf)


(defun decode-entities (html)
  (with-temp-buffer
    (save-excursion (insert html))
    (xml-parse-string)))

(defun elfeed-show-author (rss item db-entry)
  (let ((author (or (xml-query* (author *) item)
		    (xml-query* (creator *) item))))
    (let ((author-list (cl-loop with start = 0
				while (string-match "<a[^>]*?>\\(.+?\\)</a>" author start)
				collect (match-string 1 author)
				do (setq start (match-end 0)))))
      (let ((author-clean (decode-entities (string-join author-list ", "))))
	(setf (elfeed-meta db-entry :author) author-clean)
	;; (print (elfeed-meta db-entry :author))
	))))

(defun elfeed-filter (entry keyword tag untag &optional search-content)
  (when (and tag (symbolp tag)) (setf tag (list tag)))
  (when (and untag (symbolp untag)) (setf untag (list untag)))
  (let ((title (elfeed-entry-title entry))
	(content (elfeed-deref (elfeed-entry-content entry)))
	(search-content (or search-content t)))
    (when (string-match-p keyword title) (apply #'elfeed-tag entry tag) (apply #'elfeed-untag entry untag))
    (when (and search-content (string-match-p keyword content)) (apply #'elfeed-tag entry tag) (apply #'elfeed-untag entry untag))))

;; show author
(add-hook 'elfeed-new-entry-parse-hook 'elfeed-show-author)

;; UPDATED
(add-hook
 'elfeed-new-entry-hook
 (lambda (entry) (funcall 'elfeed-filter entry "\\b\\(UPDATED\\)\\b" '(updated) '(unread) nil)))

;; continual learning
(add-hook
 'elfeed-new-entry-hook
 (lambda (entry) (funcall 'elfeed-filter entry
			  "\\b\\(continual learning\\|life-long\\|lifelong\\|catastrophic forgetting\\|catastrophic interference\\|rehearse\\|rehearsal\\)\\b"
			  '(continual *) '())))
;; reinforcement learning
(add-hook
 'elfeed-new-entry-hook
 (lambda (entry) (funcall 'elfeed-filter entry
			  "\\b\\(reinforcement\\|reinforce\\|agent\\|actor critic\\|policy\\)\\b" '(rl) '())))

;; not interested
(add-hook
 'elfeed-new-entry-hook
 (lambda (entry) (funcall 'elfeed-filter entry
			  "\\b\\(medical\\|imaging\\|EEG\\|gene\\|cancer\\|diabetes\\|patient\\|MRI\\|disease\\|biomedical\\)\\b"
			  '(medical hide) '(unread))))
(add-hook
 'elfeed-new-entry-hook
 (lambda (entry) (funcall 'elfeed-filter entry
			  "\\b\\(financial\\|malware\\|android\\|wifi\\|FPGA\\|music\\|SQL\\|face recognition\\|object detection\\|privacy\\|question answering\\|social media\\|knowledge graph\\|compressive sensing\\|speaker\\|dialogue\\|remote-sensing\\|urban\\)\\b"
			  '(others hide) '(unread))))

;; stupid
(add-hook
 'elfeed-new-entry-hook
 (lambda (entry) (funcall 'elfeed-filter entry
			  "\\b\\(extreme learning machine\\|ELM\\)\\b" '(stupid hide) '(unread))))

(require 'elfeed-goodies)
(elfeed-goodies/setup)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elfeed-search-title-face ((t (:foreground "brightgreen"))))
 '(elfeed-search-unread-count-face ((t (:foreground "brightred"))))
 '(elfeed-search-unread-title-face ((t (:foreground "white")))))

;; emacs default browser
(setq browse-url-browser-function 'browse-url-chrome)
(setq markdown-command "pandoc --from markdown -t html5 --mathjax='https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-MML-AM_CHTML' --highlight-style pygments")
(setq markdown-enable-math t)
(setq markdown-preview-javascript (list "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-MML-AM_CHTML"))
(setq markdown-preview-stylesheets (list "http://thomasf.github.io/solarized-css/solarized-light.min.css"))
(global-set-key (kbd "C-x w") 'elfeed)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(custom-safe-themes
   (quote
    ("4c9ba94db23a0a3dea88ee80f41d9478c151b07cb6640b33bfc38be7c2415cc4" "9d91458c4ad7c74cf946bd97ad085c0f6a40c370ac0a1cbeb2e3879f15b40553" "e9460a84d876da407d9e6accf9ceba453e2f86f8b86076f37c08ad155de8223c" "98cc377af705c0f2133bb6d340bf0becd08944a588804ee655809da5d8140de6" "08b8807d23c290c840bbb14614a83878529359eaba1805618b3be7d61b0b0a32" default)))
 '(elfeed-goodies/entry-pane-position (quote top))
 '(elfeed-goodies/entry-pane-size 0.5)
 '(elfeed-goodies/powerline-default-separator (quote bar))
 '(elfeed-goodies/tag-column-width 32)
 '(elfeed-search-filter "@7-days-ago -hide -updated")
 '(elfeed-show-entry-author t)
 '(elfeed-use-curl t)
 '(elfeed-web-enabled nil)
 '(hl-sexp-background-color "#1c1f26")
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(package-selected-packages
   (quote
    (protobuf-mode google-c-style magit-find-file magit-gh-pulls magit-gitflow magit-lfs magit-popup elfeed-web elfeed-org elfeed-goodies elfeed fill-column-indicator slack oauth2 oauth zenburn-theme zenburn yaml-mode visual-regexp-steroids swiper spacegray-theme smart-tab scala-mode python-environment powerline outline-magic nzenburn-theme multiple-cursors material-theme markdown-mode markdown-mode+ magit json-mode js2-mode ibuffer-projectile ibuffer-git helm-themes helm-projectile helm-gtags gh-md ggtags esup epc emacs-cl elpy dakrone-theme cython-mode ctags-update ctags column-enforce-mode cmake-font-lock auto-complete swift-mode magit-svn elpy yasnippet-snippets yasnippet pdf-tools magithub gitlab flycheck)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(python-indent-offset 4)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))

;; install the missing packages
(dolist (package package-selected-packages)
  (unless (package-installed-p package)
    (package-install package)))
