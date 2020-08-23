(defun mythemes ()
  '(let* ((current-window-width (window-width))
          (active (powerline-selected-window-active))
          (separator-left (intern (format "powerline-%s-%s"
                                          (powerline-current-separator)
                                          (car powerline-default-separator-dir))))
          (separator-right (intern (format "powerline-%s-%s"
                                           (powerline-current-separator)
                                           (cdr powerline-default-separator-dir))))
          (mode-line-face (if active 'mode-line 'mode-line-inactive))
          (evil-mode-active (featurep 'evil))
          (visual-block (if evil-mode-active
                            (and (evil-visual-state-p)
                                 (eq evil-visual-selection 'block))
                          nil))
          (visual-line (if evil-mode-active
                           (and (evil-visual-state-p)
                                (eq evil-visual-selection 'line))
                         nil))
          (current-evil-state-string (if evil-mode-active
                                         (upcase (concat (symbol-name evil-state)
                                                         (cond (visual-block "-BLOCK")
                                                               (visual-line "-LINE"))))
                                       nil))
          ;; Shorten evil state to a single charater instead of the full word
          (current-evil-state-string (if (and current-evil-state-string
                                              (< current-window-width 80))
                                         (substring current-evil-state-string 0 1)
                                       current-evil-state-string))
          (outer-face (if active 'airline-normal-outer 'powerline-inactive1))
          (inner-face (if active 'airline-normal-inner 'powerline-inactive2))
          (center-face (if active 'airline-normal-center 'airline-inactive3))

          ;; Left Hand Side
          (lhs-mode (when (or (not airline-hide-state-on-inactive-buffers)
                              (and airline-hide-state-on-inactive-buffers active))
                      (list
                         ;; Modified string
                         (powerline-raw "%*" outer-face 'l)
                         ;; Separator >
                         (powerline-raw " " outer-face)
                         (funcall separator-left outer-face center-face))))

          (lhs-rest (list
                     ;; ;; Separator >
                     ;; (powerline-raw (char-to-string #x2b81) inner-face 'l)

                     ;; Eyebrowse current tab/window config
                     (if (and (or (not airline-hide-eyebrowse-on-inactive-buffers)
                                  (and airline-hide-eyebrowse-on-inactive-buffers active))
                              (featurep 'eyebrowse))
                         (powerline-raw (concat " " (eyebrowse-mode-line-indicator)) inner-face 'r))

                     ;; Git Branch
                     ;; (if (and (or (not airline-hide-vc-branch-on-inactive-buffers)
                     ;;              (and airline-hide-vc-branch-on-inactive-buffers active))
                     ;;          buffer-file-name vc-mode)
                     ;;     (powerline-raw (airline-get-vc) inner-face))

                     ;; Separator >
                     ;; (powerline-raw " " inner-face)
                     ;; (funcall separator-left inner-face center-face)

                     ;; Directory
                     (cond
                      ((and buffer-file-name ;; if buffer has a filename
                            (eq airline-display-directory
                                'airline-directory-shortened))
                       (powerline-raw (airline-shorten-directory default-directory airline-shortened-directory-length) center-face 'l))
                      ((and buffer-file-name ;; if buffer has a filename
                            (eq airline-display-directory
                                'airline-directory-full))
                       (powerline-raw default-directory center-face 'l))
                      (t
                       (powerline-raw " " center-face)))

                     ;; Buffer ID
                     ;; (powerline-buffer-id center-face)
                     (powerline-raw "%b" center-face)

                     ;; Current Function (which-function-mode)
                     (when (and (boundp 'which-func-mode) which-func-mode)
                       ;; (powerline-raw which-func-format 'l nil))
                       (powerline-raw which-func-format center-face 'l))

                     ;; ;; Separator >
                     ;; (powerline-raw " " center-face)
                     ;; (funcall separator-left mode-line face1)

                     (when (boundp 'erc-modified-channels-object)
                       (powerline-raw erc-modified-channels-object center-face 'l))

                     ;; ;; Separator <
                     ;; (powerline-raw " " face1)
                     ;; (funcall separator-right face1 face2)
                     ))

          (lhs (append lhs-mode lhs-rest))

          ;; Right Hand Side
          (rhs (list (powerline-raw global-mode-string center-face 'r)

                     ;; ;; Separator <
                     ;; (powerline-raw (char-to-string #x2b83) center-face 'l)

                     ;; Minor Modes
                     ;; (powerline-minor-modes center-face 'l)
                     ;; (powerline-narrow center-face 'l)

                     ;; Subseparator <
                     ;; (powerline-raw (char-to-string airline-utf-glyph-subseparator-right) center-face 'l)

                     ;; Major Mode
                     ;; (powerline-major-mode center-face 'l)
                     ;; (powerline-process center-face)

                     ;; Separator <
                     (powerline-raw " " center-face)
                     (funcall separator-right center-face inner-face)

                     ;; ;; Buffer Size
                     (when powerline-display-buffer-size
                       (powerline-buffer-size inner-face 'l))
                     ;; ;; Mule Info
                     (when powerline-display-mule-info
                       (powerline-raw mode-line-mule-info inner-face 'l))
                     (powerline-raw " " inner-face)
                     (powerline-raw (format " %s " buffer-file-coding-system) inner-face)

                     ;; Separator <
                     (funcall separator-right inner-face outer-face)

                     ;; % location in file
                     (powerline-raw "%3p" outer-face 'l)
                     ;; LN charachter
                     (powerline-raw (char-to-string airline-utf-glyph-linenumber) outer-face 'l)

                     ;; Current Line / File Size
                     ;; (powerline-raw "%l/%I" outer-face 'l)
                     ;; Current Line / Number of lines
                     (powerline-raw
                      (format "%%l/%d" (count-lines (point-min) (point-max))) outer-face 'l)

                     (powerline-raw "ln :" outer-face 'l)
                     ;; Current Column
                     (powerline-raw "%3c " outer-face 'l)

                     ;; ;; position in file image
                     ;; (when powerline-display-hud
                     ;;   (powerline-hud inner-face outer-face))
                     )
               ))
     ;; Combine Left and Right Hand Sides
     (concat (powerline-render lhs)
             (powerline-fill center-face (powerline-width rhs))
             (powerline-render rhs))))

(defun airline-my-theme ()
  "Set the airline mode-line-format"
  (interactive)
  (setq-default mode-line-format
                `("%e"
                  (:eval
                   ,(mythemes)
                   )))
)
