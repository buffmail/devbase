;; tab expansion for powershell v 0.1
;; by Jay Kint
;; Copyright 2008 Jay Kint
;;
;; This software, meaning the portion encapsulated by --tabexpansion-- comments, is licensed under the
;; Microsoft Public License
;; (found at http://www.microsoft.com/resources/sharedsource/licensingbasics/publiclicense.mspx)
;;
;; THIS SOFTWARE AND ARE PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
;; BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;; DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
;; EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;; LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
;; ANY WAY OUT OF THE USE OF THIS SOFTWARE OR THESE INSTRUCTIONS, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
;; DAMAGE.

;; --tabexpansion--

(require 'cl)

(defvar *original-line* nil)
(defvar *last-line* "")
(defvar *ps-tab-completions* nil)
(defvar *ps-tab-index* 0)

(defun insert-tab-completion (last-word)
  (let ((beginning-last (- (point) (length last-word))))
    (unless beginning-last
      (setq beginning-last 0))
    (goto-char beginning-last)
    (unless (eolp) (kill-line)))
  (insert (nth *ps-tab-index* *ps-tab-completions*))
  (incf *ps-tab-index*)
  (if (>= *ps-tab-index* (length *ps-tab-completions*))
      (setq *ps-tab-index* 0)))

(defun get-last-word (line)
  (let ((quote-quote (string-match "\"[^\"]+\"$" line))
        (quote-end (string-match "\"[^\"]+$" line))
        (last-non-whitespace (string-match "[^ \t]+$" line)))
    (cond
     (quote-quote (substring line quote-quote))
     (quote-end (substring line quote-end))
     (last-non-whitespace (substring line last-non-whitespace))
     (t "") )))

(defun ps-tab-expand ()
  "Tab completion emulation for PowerShell in Emacs.
Works by sending the TabExpansionEmacs command to Powershell and reading the output the first
time tab is hit.  Subsequent times just rotate through the output lines one at a time until
the line is changed."
  (interactive)
  (let* ((proc (get-buffer-process (current-buffer)))
         (pmark (process-mark proc))
         (point (point))
         (line (buffer-substring-no-properties pmark point)) )
    ; if they type something besides tab, then set the new line to build the tab completions from
    (if (not (string= line *last-line*))
        (setq *original-line* line))
    ; if we're at an empty completions queue or they typed something new
    (if (or (null *ps-tab-completions*) (not (string= line *last-line*)))
        (progn
          (let* ((old-proc-filter (process-filter proc))
                 (last-word (get-last-word *original-line*))
                 ; don't forget the newline at the end
                 (tab-expand-cmd (concat "TabExpansionEmacs -line \"" *original-line* "\" -lastWord \"" last-word "\"\n"))
                 (last-len 0) )
            ; reset to empty
            (setq *ps-tab-completions* nil)
            (when (not (string= last-word *original-line*))
              (progn
                (condition-case err
                    (progn
                      ; set the process filter to simply concatenate all the strings that we receive from powershell
                      (set-process-filter
                       proc
                       (lambda (proc str)
                         (setq *ps-tab-completions* (concat *ps-tab-completions* str)) ))
                      ; send the tab command
                      (process-send-string proc tab-expand-cmd)
                      ; get the initial output
                      (accept-process-output proc 1)
                      ; for some reason, accept-process-output doesn't always get all the output, so
                      ; if there is any left we loop until we get it all
                      (while (not (= (length *ps-tab-completions*) last-len))
                        (setq last-len (length *ps-tab-completions*))
                        (accept-process-output proc 0 100) ))
                  (error message "%s" (error-message-string err)) )
                ; restore our old filter
                (set-process-filter proc old-proc-filter)
                (if (not (null *ps-tab-completions*))
                    (progn
                      ; break the string into a list of lines
                      (setq *ps-tab-completions*
			    (cdr
			     (cdr(cdr (split-string *ps-tab-completions* "\n")))))
                      ; strip the spaces at the end of each line
                      (setq *ps-tab-completions*
                            (mapcar (lambda (path)
                                      (if (> (length path) 0)
                                          (progn
                                            (string-match "\\(.+?\\)[ ]*$" path)
                                            (let ((new-path (replace-match "\\1" t nil path nil)))
                                              (let ((contains-spaces (not (null (string-match " " new-path)))))
                                                (if contains-spaces
                                                    (setq new-path (concat "\"" new-path "\"")))
                                                new-path )))
                                        nil ))
                                    *ps-tab-completions* ))
                      ; remove problematic blank strings
                      (setq *ps-tab-completions*
			    (remove* nil *ps-tab-completions*)
			    )
		      
                      ; set variables for the first tab expansion
                      (setq *ps-tab-index* 0)
                      (insert-tab-completion last-word) ))))))
      ; otherwise just put in the next one in the list
      (let ((last-word (get-last-word line)))
        (insert-tab-completion last-word) ))
    ; save the new insertion as the last line to compare against
    (setq *last-line* (buffer-substring-no-properties pmark (point))) ))

(defun reset-ps-tabs ()
  (interactive)
  (setq *ps-tab-completions nil)
  (setq *ps-tab-index* 0)
  (setq *last-line* "")
  (setq *original-line* nil) )

;; --tabexpansion--
