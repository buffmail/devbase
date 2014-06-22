(add-to-list 'load-path "d:/devbase/conf/emacs/")

(autoload
  'powershell "powershell" "Start a interactive shell of PowerShell." t)

(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-hook 'lua-mode-hook 'turn-on-font-lock)
(autoload
  'powershell-mode "powershell-mode" "A editing mode for Microsoft Powershell." t)
(add-to-list
 'auto-mode-alist '("\\.ps1\\'" . powershell-mode)) ; PowerShell script

(add-hook 'emacs-lisp-mode-hook (lambda () (show-paren-mode t)))
(add-hook 'powershell-launch-hook
	  (lambda ()
	    (progn (load "Powershell-tab.el")
		   (local-set-key [tab] 'ps-tab-expand)
		   nil)))

(server-start)
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
(set-background-color "cornsilk")

(defun newps ()
  (interactive)
  (let ((i 1))
	(while (get-buffer (format "*ps%d" i))
	  (setq i (+ 1 i)))
	(powershell (format "*ps%d" i))))

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

(when (not (display-graphic-p))
  (global-hl-line-mode)
  (set-face-background hl-line-face "gray13"))
