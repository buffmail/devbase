(require 'package)
(require 'org)
(require 'whitespace)

(let ((pcname (getenv "COMPUTERNAME")))
  (cond
   ((string= pcname "BUFFNOTE")
	(setq my_devbase "c:/devbase/")
	(setq my_bash "C:/Program Files (x86)/Git/bin/sh.exe")
	(setq my_workdir "c:/work"))
   ((string= pcname "XL0347-P5")
	(setq my_devbase "d:/devbase/")
	(setq my_bash "D:/Programs/Git/bin/sh.exe")
	(dired "C:/Work/X3/Game/db")
	(setq my_workdir "c:/work"))
   ((string= pcname "BUFFMAIL-PC")
	(setq my_devbase "d:/devbase/")
	(setq my_bash "D:/Programs/Git/bin/sh.exe")
	(setq my_workdir "d:/workspace"))))

(add-to-list 'load-path (concat my_devbase "conf/emacs/"))

(add-hook 'emacs-lisp-mode-hook (lambda () (show-paren-mode t)))

(server-start)
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
(set-background-color "cornsilk")

(setq default-tab-width 4)
(menu-bar-mode -1)
(tool-bar-mode -1)

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

(when (not (display-graphic-p))
  (global-hl-line-mode)
  (set-face-background hl-line-face "gray13")
  (require 'color-theme)
  (eval-after-load "color-theme"
	'(progn
	   (color-theme-initialize)
	   (color-theme-charcoal-black))))

(if (equal system-type 'windows-nt)
    (progn (setq explicit-shell-file-name my_bash)
           (setq shell-file-name "bash")
           (setq explicit-sh.exe-args '("--login" "-i"))
           (setenv "SHELL" shell-file-name)
           (add-hook 'comint-output-filter-functions
					 'comint-strip-ctrl-m))
		   ; unset shift-space (using windows ime)
           (global-unset-key (kbd "S-SPC")))


(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))

(add-hook 'prog-mode-hook 'whitespace-mode)

(global-set-key (kbd "S-C-<up>") 'enlarge-window)
(global-set-key (kbd "S-C-<down>") 'shrink-window)

(split-window)
(cd my_workdir)

(setenv "PATH"
		(concat
		 "d:/Programs/ntemacs24/bin;"
		 "C:/Program Files (x86)/ntemacs/bin;"
		 "C:/Program Files/Java/jdk1.8.0_45/bin;"
		 "C:/Python34;"
		 "C:/Python34/Scripts;"
		 (getenv "PATH")))

(add-to-list
 'package-archives
 '("melpa" . "http://melpa.org/packages/")
 t)
(package-initialize)

(prefer-coding-system 'utf-8)
(setq-default show-trailing-whitespace t)
