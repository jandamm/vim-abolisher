# Abolisher

[Abolish](https://github.com/tpope/vim-abolish) is nice!

I started using it and added one `Abolish` after the other.
After a while I ran [:StartupTime](https://gihub.com/tweekmonster/startuptime.vim) and all of the sudden my results were much worse than before.
Going through the results I figured it is my abolish.vim file.

After some testing I found out that `:iabbrev` is extremely fast. Even when creating many abbreviations it is way faster.

Creating many `iabbrevs` by hand sucks, so it was time to abolish vim-abolish.

## Installation

* There is a compiled version (for macOS) of `abolisher` in this repo in `bin`.

* Otherwise install [Swift](https://swift.org) and run `make` or `make install`.

## Usage

### One Abolish file

If you have one file where all your `Abolish` lives in, move it out of your vim runtime or change the extension to something else.
Then run `abolisher abolish.txt > abolish.vim`.

This will output every line in this file and every line starting with "Abolish" will be expanded to the corresponding `iabbrev`.

### Having Abolish spread over your vim runtime

This isn't working very well as `abolisher` doesn't mutate the input file. So you would have both `Abolish` and `iabbrev` in your config.

If you want to test `abolisher` nonetheless you can provide it a list of files and it will output only abolished lines

`abolisher . > abolish.vim`

When you want to test your speed improvement you need to remove all "Abolish" lines:

`sed -i '' '/^Abolish/d' **/*.vim`

## Speed improvement

I tested mainly with [tpopes own dotfiles](https://github.com/tpope/tpope/blob/master/.vim/after/plugin/abolish_tpope.vim).

On my machine sourcing this file took **31.3** milliseconds (average over 100 runs with StartupTime).
The corresponding file created with `abolisher` took **1.5** milliseconds to load while still providing the same results.
This is **20** times less.

I still use vim-abolish for its `:S` command and sometimes for `:Abolish` when I need it just in this file/session.

## Where to go from here?

* I may add a way to configure the implicit behaviour of including every line or just "^Abolish" lines

## Differences/Bugs

* `abolisher` does not accept spaces in the replace part. I don't have the need right now but maybe add it later
* Create a bug if you spot a difference...
