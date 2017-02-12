# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew casks need Homebrew to install." && return 1

# Hack to show the first-run brew-cask password prompt immediately.
brew cask info this-is-somewhat-annoying 2>/dev/null

l0=(
  1password
  alfred
  divvy
)

# Homebrew casks
l1=(

  # Applications
  a-better-finder-rename
  box-sync
  charles
  chefdk
  codekit
  cyberduck
  dash
  dropbox
  duet
  evernote
  fastscripts
  filezilla
  firefox
  flux
  google-chrome
  hex-fiend
  imageoptim
  intellij-idea
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
  postman
  screenhero
  sequel-pro
  simpless
  skype
  slack
  sonos
  sourcetree
  spotify
  sublime-text
  the-unarchiver
  thinkorswim
  vagrant
  virtualbox
  vlc
  vmware-horizon-client
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

# Compile array of casks to install based on installation level
for i in $(seq "$(get_install_type)" -1 0); do
  eval arr=("\${"l"$i[@]}")
  casks=("${casks[@]}" "${arr[@]}")
done

brew_install_casks

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
