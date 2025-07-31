#lang racket/base

(require "doc-string.rkt")

(define* (make-fun-box val)
  "Like a box, but the identifier is used like for parameters.
  On the contrary to parameters, the value of a fun-box is shared by all threads."
  (let ([var val])
    (case-lambda
      [() var]
      [(new-val) (set! var new-val)])))

(define* current-display  (make-fun-box #f))
(define* rawind-debug      (make-fun-box #f))
(define* exit-rawind?      (make-fun-box #f))
(define* restart-rawind?   (make-fun-box #f))

(define* rawind-app-name               "Rawind")
(define* rawind-version                '(0 1))
(define* rawind-app-description        "Window manager in the Racket programming language")
(define* rawind-dir-name               "rawind")
(define* rawind-user-config-file-name  "config.rkt")
(define* rawind-env-config-var         "RAWIND_CONFIG_FILE")
(define* rawind-website                "http://github.com/megalisp/rawind")
(define* rawind-tcp-port               54321)
(define* rawind-log-file
  (build-path (find-system-path 'home-dir) "rawind.log"))

(define* user-files-dir "user-files")

; Defines if a window is protected.
; Used (at least) in workspace.rkt to avoid circular dependencies with window.rkt
; (it's not pretty but that seems the most reasonnable thing to do for now.)
(define* window-user-killable? #f)
(define* (set-window-user-killable? proc)
  (set! window-user-killable? proc))

