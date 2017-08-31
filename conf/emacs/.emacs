(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(let ((req-package-list '(python-mode helm fill-column-indicator names
                                      tabbar-ruler tabbar jade-mode
                                      sws-mode multi-web-mode
                                      web-mode org)))
  (mapcar (lambda (x) (unless (package-installed-p x)
              (message "Installing package %s" x)
              (package-install x)))
   req-package-list))

(require 'evil)
(require 'fill-column-indicator)
(require 'helm)
(require 'org)
(require 'server)
(require 'whitespace)

(let ((pcname (getenv "COMPUTERNAME")))
  (setq my_devbase "c:/devbase/")
  (setq my_bash "C:/msys64/usr/bin/bash.exe")
  (setq my_workdir "c:/work/")
  (cond
   ((string= pcname "BUFFNOTE")
    (setq my_bash "C:/msys64/usr/bin/f_bash.exe"))
   ((string= pcname "XL0347-P1")
    (setq my_devbase "d:/devbase/")
    (setq my_bash (concat user-emacs-directory "fakecygpty/f_bash.exe"))
    (setq my_workdir "e:/work/"))
   ((string= pcname "BUFFMAIL-PC")
    (setq my_devbase "d:/devbase/")
    (setq my_workdir "d:/workspace/"))))

(add-to-list 'load-path (concat my_devbase "conf/emacs/"))

(require 'org-fold)

(add-hook 'emacs-lisp-mode-hook
          (lambda () (show-paren-mode t)))

(add-hook 'after-init-hook
          (lambda ()
            (unless (server-running-p)
              (server-start))))

(add-hook 'prog-mode-hook
          'whitespace-mode)

(remove-hook 'kill-buffer-query-functions
             'server-kill-buffer-query-function)

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
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(ls-lisp-dirs-first t)
 '(ls-lisp-format-time-list (quote ("" "")))
 '(ls-lisp-use-localized-time-format t)
 '(ls-lisp-verbosity nil)
 '(org-agenda-files nil)
 '(package-selected-packages
   (quote
    (names helm fill-column-indicator tabbar-ruler tabbar jade-mode sws-mode multi-web-mode web-mode org)))
 '(paradox-github-token t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun my-current-directory (text)
  (if (string-match
       "\n\\[34m/\\([[:alpha:]*]\\)\\(.*\\)\\[31m.*\n\$ " text)
      (let ((windir (concat (substring text (match-beginning 1)(match-end 1))
                            ":"
                            (substring text (match-beginning 2)(match-end 2)))))
        (cd windir))))

(if (equal system-type 'windows-nt)
    (progn (setq explicit-shell-file-name my_bash)
           (setq shell-file-name "bash")
           (setq explicit-sh.exe-args '("--login" "-i"))
           (setenv "SHELL" shell-file-name)
           (add-hook 'comint-output-filter-functions
                     'comint-strip-ctrl-m)
           (add-hook 'comint-output-filter-functions
                     'my-current-directory))
           ; unset shift-space (using windows ime)
           (global-unset-key (kbd "S-SPC")))

(setq whitespace-line-column 80) ;; limit line length

(global-set-key (kbd "S-C-<up>") 'enlarge-window)
(global-set-key (kbd "S-C-<down>") 'shrink-window)

(split-window)

(setenv "PATH" (concat "C:/Program Files/Java/jdk1.8.0_45/bin;"
                       "c:/MSys64/usr/bin;"
                       "C:/Program Files (x86)/MSBuild/14.0/Bin;"
                       "C:/Program Files/Git/cmd/;"
                       (getenv "PATH")))

(setenv "my_workdir" my_workdir)

(add-to-list 'auto-mode-alist '("\\.pug\\'" . jade-mode))

(prefer-coding-system 'utf-8)

(setq whitespace-style '(face spaces tabs trailing tab-mark space-mark))
(setq-default indent-tabs-mode nil)

(setq tabbar-ruler-global-tabbar t)
(tabbar-ruler-move)
(tabbar-ruler-group-by-projectile-project)
(global-set-key [(control tab)] 'tabbar-forward-tab)
(global-set-key [(control shift tab)] 'tabbar-backward-tab)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(define-key org-mode-map [(control tab)] nil)
(define-key org-mode-map [(control shift tab)] nil)
(add-hook 'org-mode-hook (lambda () (visual-line-mode t)))

(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x b") #'helm-buffers-list)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)

(global-hl-line-mode)

(evil-mode 1)

(global-set-key [(kana)] 'toggle-input-method)
(global-set-key [(kanji)] 'hangul-to-hanja-conversion)

(let ((dife (expand-file-name (concat user-emacs-directory "dife/DIFE.exe"))))
  (if (file-exists-p dife)
      (w32-shell-execute nil dife)))

(desktop-save-mode 1)
