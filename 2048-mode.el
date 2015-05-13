(defvar 2048-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "w") '2048-up)
    (define-key map (kbd "s") '2048-down)
    (define-key map (kbd "a") '2048-left)
    (define-key map (kbd "d") '2048-right)
    (define-key map (kbd "r") '2048-restart)
    map)
  "2048-mode key map")

(defface 2048-base-face
  '((t (:slant oblique :weight ultra-bold :background "black")))
  "base face gor 2048")
(defface 2048-2-face
  '((t (:inherit 2048-base-face :background "blue")))
  "face for 2")
(defface 2048-4-face
  '((t (:inherit 2048-base-face :background "red")))
  "face for 4")
(defface 2048-8-face
  '((t (:inherit 2048-base-face :background "yellow")))
  "face for 8")
(defface 2048-16-face
  '((t (:inherit 2048-base-face :background "MediumPurple2")))
  "face for 16")
(defface 2048-32-face
  '((t (:inherit 2048-base-face :background "plum2")))
  "face for 32")
(defface 2048-64-face
  '((t (:inherit 2048-base-face :background "maroon3")))
  "face for 64")
(defface 2048-128-face
  '((t (:inherit 2048-base-face :background "wheat1")))
  "face for 128")
(defface 2048-256-face
  '((t (:inherit 2048-base-face :background "khaki1")))
  "face for 256")
(defface 2048-512-face
  '((t (:inherit 2048-base-face :background "white")))
  "face for 512")
(defface 2048-1024-face
  '((t (:inherit 2048-base-face :background "bisque")))
  "face for 1024")
(defface 2048-2048-face
  '((t (:inherit 2048-base-face :background "goldenrod1")))
  "face for 2048")
;; (defface 2048-delimiter-face
;;   '((t (:inherit 2048-base-face :foreground "green" :background "green")))
;;   "分隔符")

(setq 2048-keywords
      '((" 2048" . '2048-2048-face)
	(" 1024" . '2048-1024-face)
	("  512" . '2048-512-face)
	("  256" . '2048-256-face)
	("  128" . '2048-128-face)
	("   64" . '2048-64-face)
	("   32" . '2048-32-face)
	("   16" . '2048-16-face)
	("    8" . '2048-8-face)
	("    4" . '2048-4-face)
	("    2" . '2048-2-face)
	("    0" . '2048-base-face)))
	;; ("-\\||" . '2048-delimiter-face)))

(define-derived-mode 2048-mode fundamental-mode "2048"
  "a mode for 2048 game"
  (setq font-lock-defaults '(2048-keywords))
  )

(add-hook '2048-mode-hook (lambda ()
			    (message "init ....")
			    (setq 2048-current-map (make-list 16 0))
			    (2048-update-map)
			    (message "done")))


(defun 2048-update-map ()
  (erase-buffer)
  (2048-generate-2-or-4-randomly)
  (2048-print-map 2048-current-map))

(defun 2048-restart ()
  (interactive)
  (2048-mode))

(defun 2048-up ()
  (interactive)
  (let ((old-map 2048-current-map)
	(new-map (2048-up-merge 2048-current-map)))
    (if (equal old-map new-map)
	(if (2048-fail?)
	    (message "死掉了")
	  nil)
      (progn
	(setq 2048-current-map (2048-up-merge 2048-current-map))
	(2048-update-map)))
    ))

(defun 2048-down ()
  (interactive)
  (let ((old-map 2048-current-map)
	(new-map (2048-down-merge 2048-current-map)))
    (if (equal old-map new-map)
	(if (2048-fail?)
	    (message "死掉了")
	  nil)
      (progn
	(setq 2048-current-map (2048-down-merge 2048-current-map))
	(2048-update-map)))
    ))

(defun 2048-left ()
  (interactive)
  (let ((old-map 2048-current-map)
	(new-map (2048-left-merge 2048-current-map)))
    (if (equal old-map new-map)
	(if (2048-fail?)
	    (message "死掉了")
	  nil)
      (progn
	(setq 2048-current-map (2048-left-merge 2048-current-map))
	(2048-update-map)))
    ))

(defun 2048-right ()
  (interactive)
  (let ((old-map 2048-current-map)
	(new-map (2048-right-merge 2048-current-map)))
    (if (equal old-map new-map)
	(if (2048-fail?)
	    (message "死掉了")
	  nil)
      (progn
	(setq 2048-current-map (2048-right-merge 2048-current-map))
	(2048-update-map)))
    ))


(defvar 2048-current-map (make-list 16 0)
  "2048 当前的情况的 map")

;; ---------------------------------------------------
(defun 2048-fail? ()
  (let ((old-map 2048-current-map)
	(up-map (2048-up-merge 2048-current-map))
	(down-map (2048-down-merge 2048-current-map))
	(left-map (2048-left-merge 2048-current-map))
	(right-map (2048-right-merge 2048-current-map)))
    (if (and (equal old-map up-map)
	     (equal old-map down-map)
	     (equal old-map left-map)
	     (equal old-map right-map))
	t
      nil)))




(defun 2048-print-map (2048-current-map)
  (dotimes (i 4)
    ;; (insert (make-string 26 ?-))
    ;; (insert "\n")
    (dotimes (j 4)
      (insert (format "%5s" (nth (+ j (* 4 i)) 2048-current-map))))
    (insert "\n")))
  ;; (insert (make-string 26 ?-)))


(defun 2048-generate-2-or-4 ()
  (if (> (random 100) 75)
      4
    2))

(defun 2048-get-empty-cell-randomly ();; (2048-current-map)
  (let ((2048-current-map-tmp 2048-current-map)
	(empty-cell '()))
    (dotimes (i 4)
      (dotimes (j 4)
	(if (= 0 (pop 2048-current-map-tmp))
	    (setq empty-cell (cons (+ j (* 4 i)) empty-cell))
	  nil)))
    (if (= 0 (length empty-cell))
	nil
	(nth (random (length empty-cell)) empty-cell))))
  

(defun 2048-generate-2-or-4-at-pos (pos)
  (setq 2048-current-map (modify-pos-list pos (2048-generate-2-or-4) 2048-current-map)))


(defun modify-pos-list (pos val lst)
  (if (= 0 pos)
      (cons val (cdr lst))
    (cons (car lst) (modify-pos-list (- pos 1) val (cdr lst)))))

(defun 2048-generate-2-or-4-randomly ()
  (let ((random-empty-cell (2048-get-empty-cell-randomly)))
    (if (null random-empty-cell)
	(error "no empty cell.")
      	(2048-generate-2-or-4-at-pos random-empty-cell))))


;; (defun 2048-merge (direction)
;;   (cond ((string= "left" direction)
;; 	 (2048-left-merge))
;; 	((string= "right" direction)
;; 	 (2048-right-merge))
;; 	((string= "up" direction)
;; 	 (2048-up-merge))
;; 	((string= "down" direction)
;; 	 (2048-down-merge))))


(defun 2048-first-n-list (n lst)
  "generate first n elements to be a list."
  (if (= 0 n)
      '()
    (cons (car lst) (2048-first-n-list (- n 1) (cdr lst))))
  )
(defun 2048-m-n-list (m n lst)
  "generate mth to nth elements to be a list"
  (if (> m n)
      (2048-m-n-list n m lst)
    (if (= 0 m)
	(2048-first-n-list n lst)
      (2048-m-n-list (1- m) (1- n) (cdr lst)))))
    

(defun 2048-left-merge (2048-current-map)
  (let ((row-1 (2048-m-n-list 0 4 2048-current-map))
	(row-2 (2048-m-n-list 4 8 2048-current-map))
	(row-3 (2048-m-n-list 8 12 2048-current-map))
	(row-4 (2048-m-n-list 12 16 2048-current-map)))
	(fset 'aux-func (lambda (row)
			  (let ((index 0)
				(shrink-time 0)
				(last-shrink-index 0))
			    (while (and (< index 3) (< shrink-time 3))
			      (setq fst (nth index row))
			      (setq snd (nth (1+ index) row))
			      ;; (insert (format "f:%s,s:%s,i:%s,sh:%s\n" fst snd index shrink-time))
			      (cond ((= 0 fst)
				     (setq row
					   (append (2048-first-n-list index row)
						   `(,snd ,@(nthcdr (+ 2 index) row) 0)))
				     ;; (setq index 0)
				     (setq index last-shrink-index)
				     (setq shrink-time (1+ shrink-time)))
				    ((= fst snd)
				     (setq row
					   (append (2048-first-n-list index row)
						   `(,(+ fst snd) ,@(nthcdr (+ 2 index) row) 0)))
				     (setq index (1+ index))
				     (setq last-shrink-index index)
				     (setq shrink-time (1+ shrink-time)))
				    ;; ((= 0 fst)
				    ;;  (setq row
				    ;; 	   (append (2048-first-n-list index row)
				    ;; 		   `(,snd ,@(nthcdr (+ 2 index) row) 0)))
				    ;;  (setq index 0)
				    ;;  (setq shrink-time (1+ shrink-time)))
				    ((not (= fst snd))
				     (setq index (1+ index)))))
			    row)))
    (let ((res-row-1 (aux-func row-1))
	  (res-row-2 (aux-func row-2))
	  (res-row-3 (aux-func row-3))
	  (res-row-4 (aux-func row-4)))
      (append res-row-1 res-row-2 res-row-3 res-row-4))))

(defun 2048-right-merge (2048-current-map)
  (let ((row-1 (reverse (2048-m-n-list 0 4 2048-current-map)))
	(row-2 (reverse (2048-m-n-list 4 8 2048-current-map)))
	(row-3 (reverse (2048-m-n-list 8 12 2048-current-map)))
	(row-4 (reverse (2048-m-n-list 12 16 2048-current-map))))
    (let ((res-map (2048-left-merge (append row-1 row-2 row-3 row-4))))
      (let ((res-row-1 (reverse (2048-m-n-list 0 4 res-map)))
	    (res-row-2 (reverse (2048-m-n-list 4 8 res-map)))
	    (res-row-3 (reverse (2048-m-n-list 8 12 res-map)))
	    (res-row-4 (reverse (2048-m-n-list 12 16 res-map))))
	(append res-row-1 res-row-2 res-row-3 res-row-4)))))


(defun 2048-extract-elem-at-pos (lst postions)
  (if (null postions)
      nil
    (cons (nth (car postions) lst) (2048-extract-elem-at-pos lst (cdr postions)))))

(defun 2048-zip (index lsts)
  (let ((res '())
	(index (if (null index) 0 index)))
    (if (= (length (nth 0 lsts)) index)
	nil
      (progn
	(dotimes (i (length lsts))
	  (setq res (cons (nth index (nth i lsts)) res)))
	(cons (reverse res) (2048-zip (1+ index) lsts))))))

(defun 2048-up-merge (2048-current-map)
  (let ((col-1 (2048-extract-elem-at-pos 2048-current-map '(0 4 8 12)))
	(col-2 (2048-extract-elem-at-pos 2048-current-map '(1 5 9 13)))
	(col-3 (2048-extract-elem-at-pos 2048-current-map '(2 6 10 14)))
	(col-4 (2048-extract-elem-at-pos 2048-current-map '(3 7 11 15))))
    (let ((res-map (2048-left-merge (append col-1 col-2 col-3 col-4))))
      (let ((mid-row-1  (2048-m-n-list 0 4 res-map))
	    (mid-row-2  (2048-m-n-list 4 8 res-map))
	    (mid-row-3  (2048-m-n-list 8 12 res-map))
	    (mid-row-4  (2048-m-n-list 12 16 res-map)))
	(let ((res-lst (2048-zip 0
				 (cons mid-row-1
				       (cons mid-row-2
					     (cons mid-row-3
						   `(,mid-row-4)))))))
	  (let ((res-row-1 (nth 0 res-lst))
		(res-row-2 (nth 1 res-lst))
		(res-row-3 (nth 2 res-lst))
		(res-row-4 (nth 3 res-lst)))
	    (append res-row-1 res-row-2 res-row-3 res-row-4)))))))

(defun 2048-down-merge (2048-current-map)
  (let ((row-4 (2048-m-n-list 0 4 2048-current-map))
	(row-3 (2048-m-n-list 4 8 2048-current-map))
	(row-2 (2048-m-n-list 8 12 2048-current-map))
	(row-1 (2048-m-n-list 12 16 2048-current-map)))
    (let ((res-map (2048-up-merge (append row-1 row-2 row-3 row-4))))
      (let ((res-row-4 (2048-m-n-list 0 4 res-map))
	    (res-row-3 (2048-m-n-list 4 8 res-map))
	    (res-row-2 (2048-m-n-list 8 12 res-map))
	    (res-row-1 (2048-m-n-list 12 16 res-map)))
	(append res-row-1 res-row-2 res-row-3 res-row-4)))))



(provide '2048-mode)

;;end
  

	
