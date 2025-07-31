#lang racket/base

;;; User configuration file

(require rawind/base
         rawind/keymap
         rawind/window
         rawind/util
         rawind/user
         rawind/launcher-base
         rawind/workspace
         rawind/policy/base
         rawind/policy/simple
         rawind/policy/tiling
         racket/class)

; Set the number of workspaces
(num-workspaces 4)

; Use a stacking policy
(current-policy (new policy-simple%))
; Uncomment this instead if you want a tiling policy
#;(current-policy (new policy-tiling%))

;;; Some key/mouse bindings

(add-bindings 
 global-keymap
 ; Open xterm with Alt/Meta-Control-t
 "M-C-t" (L* (rawind-system "xterm"))
 ; Open xclock
 "M-C-c" (L* (rawind-system "xclock -digital -update 1"))
 ; Open the application launcher. Consider also 'dmenu' or 'gmrun'.
 "M-F2"  (L* (open-launcher))
 ; Open the config file for editing, with "open" on mac or "xdg-open" or "mimeopen" on Linux
 "M-F11" (L* (open-user-config-file))
 ; Open the client of rawind for console interaction
 "M-F12" (L* (rawind-system "xterm -g 80x24+400+0 -T 'Rawind Client' -e 'racket -l rawind/client'"))
 ; Close window gracefully if possible, otherwise kill the client
 "M-F4"  (L* (delete-window (input-focus)))
 ; Give keyboard focus to the next/previous window
 "M-Tab"   (L* (policy. activate-next-window))
 "M-S-Tab" (L* (policy. activate-previous-window))
 ; Place one workspace over all heads (monitors)
 "M-Super-F5" (L* (change-workspace-mode 'single))
 ; Place one workspace per head
 "M-Super-F6" (L* (change-workspace-mode 'multi))
 ; Tiling: Move the window up or down in the hierarchy
 "Super-Page_Up"   (L* (policy. move-window 'up))
 "Super-Page_Down" (L* (policy. move-window 'down))
 )

(for ([i (num-workspaces)])
  (add-bindings
   global-keymap
   ; Switch to the i-th workspace with Super-F1, Super-F2, etc.
   (format "Super-F~a" (add1 i)) (L* (activate-workspace i))
   ; Move window to workspace and switch to workspace
   (format "S-Super-F~a" (add1 i)) (L* (move-window-to-workspace/activate (input-focus) i))
   ))

(add-bindings
 window-keymap
 ; Move window with Meta-Button1
 "M-Move1" (motion-move-window)
 ; Resize window with Meta-Button3
 "M-Move3" (motion-resize-window)
 )

(bind-click-to-activate "Press1")

(add-bindings 
 root-keymap 
 ; Quit Rawind
 "Super-S-Escape" (L* (dprintf "Now exiting.\n")
                      (exit-rawind? #t))
 ; Restart Rawind
 ; (e.g., if the config file has changed)
 "Super-C-Escape" (L* (dprintf "Now exiting and restarting.\n")
                      (restart-rawind? #t)
                      (exit-rawind? #t))
 ; Recompile and Restart Rawind
 ; (e.g., if rawind's code has changed)
 "Super-C-S-Escape" (L* (when (recompile-rawind)
                          (dprintf "Restarting...\n")
                          (restart-rawind? #t)
                          (exit-rawind? #t)))
 )
 
