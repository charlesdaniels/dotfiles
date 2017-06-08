

# original source:
# https://www.tabsoverspaces.com/233545-my-bash-like-prompt-in-powershell/

function Prompt {
  $currentDir = $pwd.Path.Replace($env:USERPROFILE, "~")
  $Host.UI.RawUI.WindowTitle = "$prefix$(Split-Path $currentDir -Leaf)"

  $prompt = '$'
  $timestamp = Get-Date
  $tsformatted = "$($timestamp.Hour):$($timestamp.Minute)"
  return "[$(whoami)@$(hostname)][$tsformatted][$currentDir]`n(ps) $prompt "
}


# import my custom modules
if (test-path "$HOME/Scripts") {
  Get-ChildItem "$HOME/Scripts/" -Filter *.psm1 | `
  Foreach-Object {
    $fullpath = Join-Path "$HOME/Scripts/" "$_" 
    Import-Module $fullpath
  }
}
