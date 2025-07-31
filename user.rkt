#lang racket/base

(require rawind/base
         rawind/util
         rawind/doc-string
         racket/file
         )

(define* cmd-line-config-file (make-fun-box #f))
(define* rawind-uds-socket (make-fun-box (find-user-config-file rawind-dir-name "rawind-socket")))

(define* (rawind-user-config-file)
  "Returns the configuration-file path for rawind (and may create the directory)."
  (or (cmd-line-config-file)
      (find-user-config-file rawind-dir-name rawind-user-config-file-name)))

(define* (open-user-config-file)
  "Tries to open the user configuration file for edition, using the system default editor."
  (define f (rawind-user-config-file))
  (unless (file-exists? f)
    (display-to-file
     "#lang racket/base
;;; User configuration file

(require rawind/keymap rawind/base rawind/util rawind/window)

"
     f #:mode 'text))
  (open-file f))

;; TODO:
;; - If loading the user file fails, fall back to a default configuration (file)?
;; - replace the `printf' by `log-error'
(define* (init-user)
  ;; Read user configuration file
  ;; It would be useless to thread it, as one would still need to call XLockDisplay
  (let ([user-f (rawind-user-config-file)])
    (when (file-exists? user-f)
      (with-handlers ([exn:fail? #;error-message-box
                                 (λ(e)(printf "Error while loading user config file ~a:\n~a\n"
                                              user-f
                                              (exn-message e)))])
        (dynamic-require user-f #f)))))
