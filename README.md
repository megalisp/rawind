<div align="center">
      <img src="logo.png" alt="rawind" height="250">
</div>


<div align="center">
  <h1>Rawind</h1>
  <h2>A Rackety Window-Manager.</h2>
</div>


> [!NOTE]  
> In transistion from / a hard-fork of the great Rwind. Below this point, is the old readme.


# RWind - The Racket Window Manager

An extensible window manager written in the [Racket programming language](http://www.racket-lang.org), meant to be highly customizable.

There is an [RWind mailing list](https://groups.google.com/forum/?fromgroups#!forum/rwind).


First some **warnings**:

* Backward compatibility will not be ensured in the 0.x branch.
* Due to a security issue in the server, the current version should not be used on multiple
  user computers, unless the server is disabled. Use at your own risk.


## Current features

* Stacking _and_ [tiling](http://en.wikipedia.org/wiki/Tiling_window_manager) support
* Client command line (repl)
* Customization of key bindings and mouse bindings
* Workspaces with two modes:
    - single mode: one workspace over all monitors
    - multi mode: one workspace per monitor
* Xinerama and RandR support
* Fullscreen
* Currently little ICCCM/EWMH compliance

All these features are in development stage.

## Installation & quick start

### 1) Install Racket

Download and install Racket at https://download.racket-lang.org

**Note**: Racket BC is currently recommended, as some FFI segfaults may occur with Racket CS.

You may need to 
[set your PATH environment variable](https://github.com/racket/racket/wiki/Set-your-PATH-environment-variable).

### 2) Install RWind
Type:
```shell
raco pkg install --auto --update-deps rwind
```
(`raco` is provided with Racket, so it should be in your path)

This will also install missing Racket dependencies such as the `x11` Racket package.

You may also need to install `libedit` (installed by default on Ubuntu at least, but not on 
Gentoo). See [here](https://github.com/Metaxal/rwind/issues/16#issue-273254092) if installation 
fails due to this missing dependency.

### 3) Configure RWind
**As a normal user** (not a super-user), type:
```shell
racket -l rwind/configure
```
And follow the instructions.
This creates a default RWind configuration file, then it asks you to choose
between a session manager or a `xinit/startx` configuration.
If you choose a session manager configuration, it will abort and you will need to re-type the 
above command preceded by `sudo`.
These two steps are required because the first configuration files must be owned by the user.

You can reconfigure RWind at any time.

### 4) Start RWind

a) If you chose a session configuration, go back to the login screen.
You should now see RWind in the login options.

b) If you chose a xinit/startx configuration, in a virtual terminal 
(`Ctrl-Alt-F1` or `Ctrl-Alt-F2`, etc.), type the following:
```shell
xinit .xinitrc-rwind -- :1 &
```

You may need to modify the display `:1` to `:2` for example if `:1` is not available. The default 
`.xinitrc-rwind` is a simple example file that you may want to edit to fit your needs. By 
default, you need to close the xterms to exit the session.

<!--
### c) Replace your current window manager

It is also possible to load a normal session with your usual window manager,
then kill it and replace it with RWind.
For example, supposing you are using Metacity:
```shell
killall metacity && racket -l rwind
```

Strange results are likely to show up though.
-->

## Default configuration and customization

Upon configuration, the file `config.rkt` was created.
This is where all the RWind customization is done.
By default, you can open this file within RWind by pressing `Alt-F11`
(this can also be changed in the configuration file).
Take a look at this file to know what keybindings are defined.
You can also of course add your own keybindings.

<!--
This file defines a number of keyboard and mouse bindings that you can easily redefine:
 - Alt-left-button to move a window around
 - Alt-right-button to resize the window
 - Alt-(Shift-)Tab to navigate between windows
 - Ctrl-Alt-t to open xterm
 - Alt-F4 to close a window
 - Alt-F12 opens the client (see below)
 - Super-F{1-4} switches between workspaces
 - Shift-Super-F{1-4} moves the current window to another workspace
 - Alt-Super-F5 switches to `single` workspace mode
 - Alt-Super-F6 switches to `multi` workspace mode
 - Super-Page{Up,Down} moves the window up/down in tiling mode
 - ...
-->

The default window policy is stacking (as for most traditional window managers), but you can 
easily change it to [tiling](http://en.wikipedia.org/wiki/Tiling_window_manager) in the 
configuration file. With the tiling policy, several layouts are possible (mainly `uniform` and 
`dwindle`). To choose a layout, specify so in the file: 

```racket
(current-policy (new policy-tiling% [layout 'dwindle]))
```

If you edit the configuration file, you will need to restart RWind to take the changes into account,
probably by pressing the keybinding as defined in this very file.
You don't need to recompile RWind, just restart it.

## The client

The client is a console where you can evaluate Racket expressions and communicate with the window 
manager. It can be opened in a terminal with:

```shell
racket -l rwind/client
```

For example, place the mouse pointer on a window and type in the console:
```racket
> (window-name (pointer-window))
```
Or:
```racket
> (move-window (pointer-window) 10 40)
```

The list of available symbols provided by RWind is given by:
```racket
> (known-identifiers)
```

All bindings of `#lang racket` are available too.

You can get help on a known identifier with:
```racket
> (describe 'focus-window)
```

You can search among the list of identifiers with:
```racket
> (search-identifiers "window")
```

You can get the list of existing layouts for the tiling policy:
```racket
> (policy. get-layouts)
```
The layout can be changed immediately:
```racket
> (policy. set-layout 'dwindle)
```

Each workspace can have its own layout:
```racket
> (policy. set-workspace-layout 'uniform)
```
To reset the layout of a workspace to the default one:
```racket
> (policy. reset-workspace-layout)
```

## Updating RWind

RWind has some dependencies, in particular the [X11 FFI bindings](https://github.com/kazzmir/x11-racket),
that will probably need to be updated with RWind.
To do this automatically, specify the `--auto` option to `raco update`:
```shell
raco update --auto rwind
```

**Your RWind configurations file will not be modified by the update.**
This also means that any new feature that may appear in the new versions of these files
will not be added to your files.
You can reconfigure RWind, and you will be asked if you want to replace the existing `config.rkt` file.

## Debugging

Because RWind heavily relies on the X11 collection, a large part of the debugging happens an the 
interface between the two.

Create symbolic links to the scripts `user-files/.xinitrc-rwind-debug` and 
`user-files/rwind-debug` in your home directory, or copy these files.

Compile rwind and x11 in debug mode with `$ user-files/compile-rwind debug`. Basically, it 
removes all previous compilations of the two collections and compiles it with some flags.

Finally, start RWind from a non-X terminal (say, Ctrl-Alt-F2):
```
xinit .xinitrc-rwind-debug -- :2 &
```

Then all error messages are redirected to `~/rwind.log`.
You should see lines starting with "RW:", and lines starting with "  X:" (for the X11 lib).
You can also track the error messages from within RWind with `tail -f ~/rwind.log`.

