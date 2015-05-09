(add-to-list 'load-path "c:/devbase/conf/emacs/")

(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-hook 'lua-mode-hook 'turn-on-font-lock)

(add-hook 'emacs-lisp-mode-hook (lambda () (show-paren-mode t)))

(server-start)
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
(set-background-color "cornsilk")

(setq default-tab-width 4)
(menu-bar-mode -1)
(tool-bar-mode -1)

(defun clear-shell ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
	(comint-truncate-buffer)))

(modify-coding-system-alist 'file "\\COMMIT_EDITMSG\\'" 'utf-8)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(setq backup-inhibited t)
(global-linum-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ls-lisp-dirs-first t)
 '(ls-lisp-format-time-list (quote ("" "")))
 '(ls-lisp-use-localized-time-format t)
 '(ls-lisp-verbosity nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(when 
	(string= (getenv "COMPUTERNAME") "XL0347-P5") 
  (dired "C:/Work/X3/Game/db")
  (split-window))

(when (not (display-graphic-p))
  (global-hl-line-mode)
  (set-face-background hl-line-face "gray13")
  (require 'color-theme)
  (eval-after-load "color-theme"
	'(progn
	   (color-theme-initialize)
	   (color-theme-charcoal-black))))

(if (equal system-type 'windows-nt)
    (progn (setq explicit-shell-file-name
                 "C:/Program Files (x86)/Git/bin/sh.exe")
           (setq shell-file-name "bash")
           (setq explicit-sh.exe-args '("--login" "-i"))
           (setenv "SHELL" shell-file-name)
           (add-hook 'comint-output-filter-functions
					 'comint-strip-ctrl-m)))
