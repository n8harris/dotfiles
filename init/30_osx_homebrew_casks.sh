# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew casks need Homebrew to install." && return 1

# Ensure the cask keg and recipe are installed.
kegs=(caskroom/cask)
brew_tap_kegs

# Hack to show the first-run brew-cask password prompt immediately.
brew cask info this-is-somewhat-annoying 2>/dev/null

# Homebrew casks
casks=(
  # Applications
  1password
  a-better-finder-rename
  alfred
  box-sync
  charles
  chefdk
  codekit
  cyberduck
  dash
  divvy
  dropbox
  duet
  evernote
  fastscripts
  filezilla
  firefox
  firefoxdeveloperedition
  flux
  google-chrome
  hex-fiend
  imageoptim
  istat-menus
  java
  kindle
  launchbar
  macdown
  mongohub
  moom
  omnidisksweeper
  omnifocus
  postico
  screenhero
  sequel-pro
  simpless
  skype
  slack
  sonos
  sourcetree
  spotify
  sublime-text3
  the-unarchiver
  thinkorswim
  utorrent
  vagrant
  virtualbox
  vlc
  vmware-horizon-view-client
  whatsapp

  # Quick Look plugins
  betterzipql
  qlcolorcode
  qlmarkdown
  qlprettypatch
  qlstephen
  quicklook-csv
  quicklook-json
  suspicious-package

  # Color pickers
  colorpicker-developer
  colorpicker-skalacolor
)

# Install Homebrew casks.
casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#casks[@]} > 0 )); then
  e_header "Installing Homebrew casks: ${casks[*]}"
  for cask in "${casks[@]}"; do
    brew cask install $cask
  done
  brew cask cleanup
fi

# Work around colorPicker symlink issue.
# https://github.com/caskroom/homebrew-cask/issues/7004
cps=()
for f in ~/Library/ColorPickers/*.colorPicker; do
  [[ -L "$f" ]] && cps=("${cps[@]}" "$f")
done

if (( ${#cps[@]} > 0 )); then
  e_header "Fixing colorPicker symlinks"
  for f in "${cps[@]}"; do
    target="$(readlink "$f")"
    e_arrow "$(basename "$f")"
    rm "$f"
    cp -R "$target" ~/Library/ColorPickers/
  done
fi
