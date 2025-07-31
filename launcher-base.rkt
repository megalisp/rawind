#lang racket/base
; launcher-base.rkt
(require rawind/base
         rawind/util
         rawind/doc-string
         racket/file
         racket/list)

(define history-max-length 50)

(define rawind-launcher-history-file
  (find-user-config-file rawind-dir-name "rawind-launcher-history.txt"))

(define* (launcher-history)
  "History of launched commands from the Rawind launcher."
  (define hist
    (if (file-exists? rawind-launcher-history-file)
        (reverse (file->lines rawind-launcher-history-file))
        null))
  ;; If history is too long, truncate it and rewrite the file
  ;; (we don't want the history to grow indefinitely)
  (when (> (length hist) (* 2 history-max-length))
    (display-lines-to-file
     (reverse (take hist history-max-length))
     rawind-launcher-history-file
     #:mode 'text
     #:exists 'replace))
  hist)

(define* (add-launcher-history! command)
  "Add to the history of launched commands."
  (with-output-to-file rawind-launcher-history-file
    (λ ()
      (printf "~a~n" command))
    #:mode 'text
    #:exists 'append))

(define* (open-launcher)
  "Show the program launcher."
  (rawind-system "racket -l rawind/launcher"))
