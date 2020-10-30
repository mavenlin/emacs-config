(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-dim-other-buffers-face ((t (:background "color-232" :foreground "black"))))
 '(elfeed-search-title-face ((t (:foreground "color-244"))))
 '(elfeed-search-unread-count-face ((t (:foreground "brightred"))))
 '(elfeed-search-unread-title-face ((t (:foreground "brightwhite")))))

(defun parse_arxiv (uri action)
  (if (eq major-mode 'bibtex-mode)
      (progn (string-match "arxiv\\.org/\\(pdf\\|abs\\)/\\([0-9]+\\.[0-9]+\\)" uri)
	     (let ((num (match-string 2 uri)))
	       (arxiv-get-pdf-add-bibtex-entry
		num (or buffer-file-name (car org-ref-default-bibliography)) org-ref-pdf-directory))
	     )))

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
   '("4c9ba94db23a0a3dea88ee80f41d9478c151b07cb6640b33bfc38be7c2415cc4" "9d91458c4ad7c74cf946bd97ad085c0f6a40c370ac0a1cbeb2e3879f15b40553" "e9460a84d876da407d9e6accf9ceba453e2f86f8b86076f37c08ad155de8223c" "98cc377af705c0f2133bb6d340bf0becd08944a588804ee655809da5d8140de6" "08b8807d23c290c840bbb14614a83878529359eaba1805618b3be7d61b0b0a32" default))
 '(dnd-protocol-alist
   '(("^https://arxiv\\.org/\\(pdf\\|abs\\)/[0-9]+\\.[0-9]+" . parse_arxiv)
     ("^\\(https?\\|ftp\\|file\\|nfs\\):" . org-download-dnd)
     ("^data:" . org-download-dnd-base64)
     ("^file:" . org-ref-pdf-dnd-protocol)
     ("^file:///" . dnd-open-local-file)
     ("^file://" . dnd-open-file)
     ("^file:" . dnd-open-local-file)
     ("^\\(https?\\|ftp\\|file\\|nfs\\)://" . dnd-open-file)
     ))
 '(ein:output-area-inlined-images t)
 '(elfeed-goodies/entry-pane-position 'top)
 '(elfeed-goodies/entry-pane-size 0.5)
 '(elfeed-goodies/powerline-default-separator 'bar)
 '(elfeed-goodies/tag-column-width 32)
 '(elfeed-search-filter "@7-days-ago -hide -updated")
 '(elfeed-show-entry-author t)
 '(elfeed-use-curl t)
 '(elfeed-web-enabled nil)
 '(hl-sexp-background-color "#1c1f26")
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(org-download-method 'attach)
 '(org-ref-create-notes-hook
   '((lambda nil
       (org-narrow-to-subtree)
       (insert
	(format "cite:%s
"
		(org-entry-get
		 (point)
		 "Custom_ID")))
       (insert "tags:"))))
 '(package-selected-packages
   '(org-download org-ref org-capture-pop-frame org-roam-server org-roam-bibtex org-roam smart-tabs-mode ein airline-themes auto-dim-other-buffers vterm tide cquery ace-window google-c-style helm-ack helm magit-find-file magit-gh-pulls magit-gitflow magit-lfs magit-popup elfeed-web elfeed-org elfeed-goodies elfeed fill-column-indicator slack oauth2 oauth zenburn-theme zenburn yaml-mode visual-regexp-steroids swiper spacegray-theme scala-mode python-environment powerline outline-magic multiple-cursors material-theme markdown-mode markdown-mode+ magit json-mode ibuffer-projectile ibuffer-git helm-themes helm-projectile helm-gtags gh-md ggtags esup epc elpy dakrone-theme cython-mode column-enforce-mode cmake-font-lock auto-complete swift-mode magit-svn elpy yasnippet-snippets yasnippet))
 '(pdf-view-midnight-colors '("#DCDCCC" . "#383838"))
 '(python-indent-def-block-scale 2)
 '(python-indent-offset 2)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   '((20 . "#BC8383")
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
     (360 . "#DC8CC3")))
 '(vc-annotate-very-old-color "#DC8CC3"))
