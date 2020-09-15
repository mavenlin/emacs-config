
;; org-roam
(unless (file-exists-p "~/org-roam") (make-directory "~/org-roam"))
(setq org-roam-directory "~/org-roam")
(add-hook 'after-init-hook 'org-roam-mode)

;; org ref
(setq reftex-default-bibliography '("~/org-roam/bibliography/reference.bib"))
;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "~/org-roam/bibliography/notes.org"
      org-ref-default-bibliography '("~/org-roam/bibliography/reference.bib")
      org-ref-pdf-directory "~/org-roam/bibliography/bibtex-pdfs/")

(setq bibtex-completion-bibliography "~/org-roam/bibliography/references.bib"
      bibtex-completion-library-path "~/org-roam/bibliography/bibtex-pdfs"
      bibtex-completion-notes-path "~/org-roam/bibliography/helm-bibtex-notes")
;; open pdf
;; (setq bibtex-completion-pdf-open-function
;;   (lambda (fpath)
;;     (start-process "open" "*open*" "open" fpath)))
(require 'org-ref)




(setq org-default-notes-file (concat org-directory "/notes.org"))

(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)
