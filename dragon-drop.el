;;; dragon-drop.el --- Drag & Drop with Dragon       -*- lexical-binding: t; -*-

;; Copyright (C) 2022  

;; Author:  <indigo@arch>
;; Keywords: convenience, files, mouse

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Requires 'dragon' cli program, 'dragon-drop' on arch linux.

;;; Code:

(defvar dragon-drop-program-name "dragon-drop"
  "Name of the cli program (differs on different distros)")

(defvar dragon-drop-default-args "--all --and-exit")
(defvar dragon-drop-always-args " --on-top ") ; surrounded by spaces so concating is easier

(defvar dragon-drop-thumb-size 96
  "Default size of thumbnails (96 is default without the argument)")

(defun dragon-drop (&optional files args thumb-size)
  "Runs `dragon-drop-program-name' on the selected buffer or the dired marked files.
By default it will send all files at once and exit (--all --and-exit).

With ARG it will stay until the user exits (with 'q').

Runs shell command the same way as `dired-do-shell-command' does (for file name parsing)."
  (interactive
   (list (if (eq major-mode 'dired-mode) (dired-get-marked-files t)
           (list (or (buffer-file-name)
                     (error "No File Selected"))))
         (cond ((equal current-prefix-arg '(4))
                dragon-drop-always-args)
               (t (concat dragon-drop-default-args dragon-drop-always-args)))
         dragon-drop-thumb-size))
  (setq command (format "%s -s %s %s &" dragon-drop-program-name
                        thumb-size args))
  (dired-run-shell-command (dired-shell-stuff-it command files nil nil)))

(provide 'dragon-drop)
;;; dragon-drop.el ends here
