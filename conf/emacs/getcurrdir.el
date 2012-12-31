(let* ((proc (get-buffer-process "*PowerShell*"))
       (old-proc-filter (process-filter proc))
       (last-len 0))
  (setq *ret* nil)
  (set-process-filter 
   proc 
   (lambda (proc str)
     (setq *ret* (concat *ret* str))))
  (process-send-string proc "pwd\n")
  (accept-process-output proc 1)
  (while (not (= (length *ret*) last-len))
    (setq last-len (length *ret*))
    (accept-process-output proc 0 100) )
  (set-process-filter proc old-proc-filter)
  (setq *ret* (cadddr (split-string *ret* "\n")))
  (when (string-match "[ \t]*$" *ret*)
    (setq *ret* (replace-match "" nil nil *ret*)))
  *ret*
)
