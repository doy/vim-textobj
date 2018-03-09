# Overview

This plugin allows configuration of custom text objects, to perform actions on
additional sections of text than Vim has built-in.

# Installation

This plugin can be installed as a standard Vim package (see `:help packages`).
Simply clone this repository into ~/.vim/pack/plugins/start/vim-textobj to
install the Vim files for this plugin.

# Configuration

Configuration is done by setting the `g:textobj_defs` variable to a dict which
maps input keys to a list containing the text object type and arguments to pass
to that type. For instance:

```
    let g:textobj_defs = {
    \    '/': ['paired'],
    \    'r': ['paired', '/'],
    \    '\|': ['paired'],
    \    'f': ['fold'],
    \    ',': ['arg'],
    \}
```

This defines five text object characters: `/` and `r` (for regex?) for text
within matching pairs of `/` characters, `|` for text within matching pairs of
`|` characters, `f` for text within the current fold, and `,` for the current
argument in a comma-separated function argument list. This, for instance,
allows you to use `di/` to delete the text within a Perl regex.

Currently, these are the available types:

* `paired`: matches text between pairs of characters. Takes one optional
  argument for the character to match between, which defaults to the input
  character.

* `fold`: matches the text within the current fold. Takes no arguments.

* `arg`: matches the current function argument. Given text like
  `foo(bar, b|az, quux)` (where `|` is the cursor location), if `,` is the
  input character, `da,` will result in `foo(bar, |quux)` and `di,` will
  result in `foo(bar, |, quux)` . Takes no arguments.
