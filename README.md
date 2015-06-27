# My dotfiles 
I was unhappy with other dotfile managment solutions available, so I decided to roll my own. Beware, this is something I designed for myself, and is still quite new. It is most likely both brittle and unstable; use at your own risk. 

## Usage 
Clone the repository. Run `deploy.py`. You will enter an interactive command session. Type `help` for help. You may list available modules with `list-modules`. Each module has a catagory and a mode. Each file in overwrite mode will replace it's corrosponding file specified in the `# file path rules` (or the file matching it's name in that directory, if a directory is specified) section. Each file in append mode will instead append to the relavant file (useful for installing multiple modules to `.bashrc`). Modules should have sane default modes, but you can override a module's mode with `set-mode`. 

## Example 
`> list-modules`

```
module listing - 11 found
name                 catagory             mode                 install             
---------------------------------------------------------------------------
aptitude             bashrc               append               no  
bin-paths            bashrc               append               no  
pacman               bashrc               append               no  
utility              bashrc               append               no  
genpw.sh             bin                  overwrite            no  
install-utils.sh     bin                  overwrite            no  
install-yaourt.sh    bin                  overwrite            no  
macos-browser.sh     bin                  overwrite            no  
words                lib                  overwrite            no  
tmux.conf            tmux                 overwrite            no  
```

`> set mode aptitude overwrite` 

`> install-module aptitude`

`> commit` 

`> install-module utility`

`> install-module bin-paths`

`> install-module words`

`> install-module genpw.sh` 

`> commit`

This command sequence would first overwrite `~/.bashrc` with the contents of the `aptitude` module (useful for wiping out older configurations). Then, the modulules `utility` and `bin-paths` would be appended to `~/.bashrc`. Finally `genpw.sh` and the required word list `words` are installed. 

## Modules 
* `aptitude` - aliases for apt-get 
* `bin-paths` - adds `~/bin` to `$PATH` 
* `pacman` - matching aliases to the `aptitude` module, but mapped to their pacman equivalants
* `utility` - a set of utility aliases and functions
* `genpw.sh` - gets five random words from `~/lib/words`, useful for creating secure passwords 
* `install-utils` - installs utilities I like, `pacman` or `aptitude` must be installed for it to work
* `install-yaourt.sh` - the yaourt installation script from the yaourt website
* `macos-browser.sh` - the browser script from my article [debian on osx](http://cdaniels.net/index.php/2015/06/25/debian-on-osx/)
* `words` - a word list of 10,000 english words
* `tmux.conf` - my tmux.conf file

## Future objectives/TODO 
* configuration rules should be provided from a file, not specified in `deploy.py`
* moduels should have some kind of format/headers, rather than being detected from directory structure
* better error checking/recovery 
