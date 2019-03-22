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
