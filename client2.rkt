#lang racket ; to load all useful procedures for evaling the client commands

(require x11/x11
         rawind/base
         rawind/util
         rawind/window
         rawind/keymap
         rawind/doc-string
         ;racket/tcp
         readline
         )

;(provide start-rawind-server)

(define-namespace-anchor server-namespace-anchor)
(define server-namespace (namespace-anchor->namespace server-namespace-anchor))
; or use module->namespace with a different module that is empty except for the requires?
; would be safer no?

(define (start-rawind-client [continuous? #t])
  (define rawind-prompt "rawind-client> ")
  (define rawind-out-prompt "")

  (current-display (XOpenDisplay #f))
  (unless (current-display)
    (error "Cannot open display.")
    (exit))

  (define (client-loop)
    (display rawind-prompt) (flush-output)
    (XSync (current-display) #f) ; sync and wait for sync'ed state
    (for ([e (in-port read)]
          #:break (equal? e '(exit))
          )
      ; if it fails, simply return the message
      (with-handlers ([exn:fail? (λ(e)
                                   (define res (exn-message e))
                                   (displayln res))])
        (define res (eval e server-namespace))
        (printf "~a~v\n" rawind-out-prompt res)
        (display rawind-prompt) (flush-output)

        ;; This seems necessary to force the server to handle our request immediately
        ;; otherwise, I sometimes see it hand until some other request is given
        (XFlush (current-display))
        )))

  (dynamic-wind
   void
   client-loop
   (λ() (XCloseDisplay (current-display)))))

(module+ main
  (rawind-debug #t)
  (start-rawind-client #f))
