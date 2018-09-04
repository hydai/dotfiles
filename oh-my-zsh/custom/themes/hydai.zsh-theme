# vim:ft=zsh ts=2 sw=2 sts=2
################################################################
# hydai's Theme
#
# This theme was modified from powerlevel9k's Theme:
# https://github.com/bhilburn/powerlevel9k
#
# The `vcs_info` hooks in this file are from Tom Upton:
# https://github.com/tupton/dotfiles/blob/master/zsh/zshrc
#
# In order for this theme to render correctly, you will need a Powerline-patched font:
# https://github.com/Lokaltog/powerline-fonts
################################################################

################################################################
# Please see the README file located in the source repository for full docs.
# What follows is a brief list of the settings variables used by this theme.
# You should define these variables in your `~/.zshrc`.
#
# Customize which segments appear in which prompts (below is also the default):
#   HYDAI_LEFT_PROMPT_ELEMENTS=(context dir vcs)
#   HYDAI_RIGHT_PROMPT_ELEMENTS=(status history time)
#
# Set your username for the `context` segment:
#   export DEFAULT_USER=<your username>
#
# Customize the format of the time segment. Example of reverse format:
#   HYDAI_TIME_FORMAT='%D{%S:%M:%H}' 
#
# Show the hash/changeset string in the `vcs` segment:
#   HYDAI_SHOW_CHANGESET=true
#
# Set the length of the hash/changeset if enabled in the `vcs` segment:
HYDAI_CHANGESET_HASH_LENGTH=6
#
# Make a double-lined prompt:
HYDAI_PROMPT_ON_NEWLINE=true
#
# Set the colorscheme:
#   HYDAI_COLOR_SCHEME='light'
################################################################

# The `CURRENT_BG` variable is used to remember what the last BG color used was
# when building the left-hand prompt. Because the RPROMPT is created from
# right-left but reads the opposite, this isn't necessary for the other side.
CURRENT_BG='NONE'

# These characters require the Powerline fonts to work properly. If see boxes or
# bizarre characters below, your fonts are not correctly installed.
LEFT_SEGMENT_SEPARATOR=''
RIGHT_SEGMENT_SEPARATOR=''
VCS_STAGED_ICON='✚'
VCS_UNSTAGED_ICON='✗'
VCS_UNTRACKED_ICON='… '
VCS_AHEAD_ICON='↑ '
VCS_BEHIND_ICON='↓ '
VCS_CONFLICTS_ICON='✖ '
VCS_STASHED_ICON='⚑'
VCS_CLEAN_ICON='✔ '

################################################################
# color scheme
################################################################

local DEFAULT_COLOR DEFAULT_COLOR_INVERTED DEFAULT_COLOR_DARK
if [[ $HYDAI_COLOR_SCHEME == "light" ]]; then
  DEFAULT_COLOR=white
  DEFAULT_COLOR_INVERTED=black
  DEFAULT_COLOR_DARK="252"
else
  DEFAULT_COLOR=black
  DEFAULT_COLOR_INVERTED=white
  DEFAULT_COLOR_DARK="236"
fi

local VCS_FOREGROUND_COLOR=$DEFAULT_COLOR
local VCS_FOREGROUND_COLOR_DARK=$DEFAULT_COLOR_DARK

# If user has defined custom colors for the `vcs` segment, override the defaults
if [[ -n $HYDAI_VCS_FOREGROUND ]]; then
  VCS_FOREGROUND_COLOR=$HYDAI_VCS_FOREGROUND
fi
if [[ -n $HYDAI_VCS_DARK_FOREGROUND ]]; then
  VCS_FOREGROUND_COLOR_DARK=$HYDAI_VCS_DARK_FOREGROUND
fi

################################################################
# VCS Information Settings
################################################################

setopt prompt_subst
autoload -Uz vcs_info

local VCS_WORKDIR_DIRTY=false
local VCS_CHANGESET_PREFIX=''
if [[ "$HYDAI_SHOW_CHANGESET" == true ]]; then
  # Default: Just display the first 6 characters of our changeset-ID.
  local VCS_CHANGESET_HASH_LENGTH=6
  if [[ -n $HYDAI_CHANGESET_HASH_LENGTH ]]; then
    VCS_CHANGESET_HASH_LENGTH=$HYDAI_CHANGESET_HASH_LENGTH
  fi

  VCS_CHANGESET_PREFIX="%F{$VCS_FOREGROUND_COLOR_DARK}%0.$VCS_CHANGESET_HASH_LENGTH""i@%f"
fi

zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' check-for-changes true

zstyle ':vcs_info:*' formats " $VCS_CHANGESET_PREFIX%F{$VCS_FOREGROUND_COLOR}%b%c%u%m%f"
zstyle ':vcs_info:*' actionformats " $VCS_CHANGESET_PREFIX%F{$VCS_FOREGROUND_COLOR}%b%c%u%m%f"

zstyle ':vcs_info:*' stagedstr " %F{$VCS_FOREGROUND_COLOR}$VCS_STAGED_ICON%f"
zstyle ':vcs_info:*' unstagedstr " %F{$VCS_FOREGROUND_COLOR}$VCS_UNSTAGED_ICON%f"

zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-aheadbehind git-stash git-remotebranch git-tagname

# For Hg, only show the branch name
zstyle ':vcs_info:hg*:*' branchformat "%b"
# The `get-revision` function must be turned on for dirty-check to work for Hg
zstyle ':vcs_info:hg*:*' get-revision true
zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*+gen-hg-bookmark-string:*' hooks hg-bookmarks

if [[ "$HYDAI_SHOW_CHANGESET" == true ]]; then
  zstyle ':vcs_info:*' get-revision true
else
  # A little performance-boost for large repositories (especially Hg). If we
  # don't show the changeset, we can switch to simple mode.
  zstyle ':vcs_info:*' use-simple true
fi

## Debugging
#zstyle ':vcs_info:*+*:*' debug true
#set -o xtrace

################################################################
# Prompt Segment Constructors
################################################################

# Begin a left prompt segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
left_prompt_segment() {
  # Overwrite given background-color by user defined variable for this segment.
  # We get as first Parameter the function name, which called this function. 
  # From the given function name, we strip the "prompt_"-prefix and uppercase it.
  # This is, prefixed with "HYDAI_" and suffixed with either "_BACKGROUND"
  # of "_FOREGROUND", our variable name. So each new Segment should automatically
  # be overwritable by a variable following this naming convention.
  local BACKGROUND_USER_VARIABLE=HYDAI_${(U)1#prompt_}_BACKGROUND
  local BG_COLOR_MODIFIER=${(P)BACKGROUND_USER_VARIABLE}
  [[ -n $BG_COLOR_MODIFIER ]] && 2=$BG_COLOR_MODIFIER

  # Overwrite given foreground-color by user defined variable for this segment.
  local FOREGROUND_USER_VARIABLE=HYDAI_${(U)1#prompt_}_FOREGROUND
  local FG_COLOR_MODIFIER=${(P)FOREGROUND_USER_VARIABLE}
  [[ -n $FG_COLOR_MODIFIER ]] && 3=$FG_COLOR_MODIFIER

  local bg fg
  [[ -n $2 ]] && bg="%K{$2}" || bg="%k"
  [[ -n $3 ]] && fg="%F{$3}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $2 != $CURRENT_BG ]]; then
    echo -n "%{$bg%F{$CURRENT_BG}%}$LEFT_SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$2
  [[ -n $4 ]] && echo -n $4
}

# End the left prompt, closing any open segments
left_prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$LEFT_SEGMENT_SEPARATOR"
  else
    echo -n " %{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# Begin a right prompt segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground. No ending for the right prompt
# segment is needed (unlike the left prompt, above).
right_prompt_segment() {
  # Overwrite given background-color by user defined variable for this segment.
  local BACKGROUND_USER_VARIABLE=HYDAI_${(U)1#prompt_}_BACKGROUND
  local BG_COLOR_MODIFIER=${(P)BACKGROUND_USER_VARIABLE}
  [[ -n $BG_COLOR_MODIFIER ]] && 2=$BG_COLOR_MODIFIER

  # Overwrite given foreground-color by user defined variable for this segment.
  local FOREGROUND_USER_VARIABLE=HYDAI_${(U)1#prompt_}_FOREGROUND
  local FG_COLOR_MODIFIER=${(P)FOREGROUND_USER_VARIABLE}
  [[ -n $FG_COLOR_MODIFIER ]] && 3=$FG_COLOR_MODIFIER

  local bg fg
  [[ -n $2 ]] && bg="%K{$2}" || bg="%k"
  [[ -n $3 ]] && fg="%F{$3}" || fg="%f"
    echo -n " %f%F{$2}$RIGHT_SEGMENT_SEPARATOR%f%{$bg%}%{$fg%} "
  [[ -n $4 ]] && echo -n $4
}

################################################################
# The 'vcs' Segment and VCS_INFO hooks / helper functions
################################################################
prompt_vcs() {
  local vcs_prompt="${vcs_info_msg_0_}"

  if [[ -n $vcs_prompt ]]; then
    if [[ "$VCS_WORKDIR_DIRTY" == true ]]; then
      $1_prompt_segment $0_MODIFIED red $DEFAULT_COLOR
    else
      $1_prompt_segment $0 green $DEFAULT_COLOR
    fi

    echo -n "%F{$VCS_FOREGROUND_COLOR}%f$vcs_prompt"
  fi
}

function +vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' && \
            $(git ls-files --others --exclude-standard | sed q | wc -l | tr -d ' ') != 0 ]]; then
        hook_com[unstaged]+=" %F{$VCS_FOREGROUND_COLOR}✗%f"
    fi
}

function +vi-git-aheadbehind() {
    local ahead behind branch_name
    local -a gitstatus

    branch_name=${$(git symbolic-ref --short HEAD 2>/dev/null)}

    # for git prior to 1.7
    # ahead=$(git rev-list origin/${branch_name}..HEAD | wc -l)
    ahead=$(git rev-list ${branch_name}@{upstream}..HEAD 2>/dev/null | wc -l | tr -d ' ')
    (( $ahead )) && gitstatus+=( " %F{$VCS_FOREGROUND_COLOR}↑${ahead// /}%f" )

    # for git prior to 1.7
    # behind=$(git rev-list HEAD..origin/${branch_name} | wc -l)
    behind=$(git rev-list HEAD..${branch_name}@{upstream} 2>/dev/null | wc -l | tr -d ' ')
    (( $behind )) && gitstatus+=( " %F{$VCS_FOREGROUND_COLOR}↓${behind// /}%f" )

    hook_com[misc]+=${(j::)gitstatus}
}

function +vi-git-remotebranch() {
    local remote branch_name

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify HEAD@{upstream} --symbolic-full-name 2>/dev/null)/refs\/(remotes|heads)\/}
    branch_name=${$(git symbolic-ref --short HEAD 2>/dev/null)}

    hook_com[branch]="%F{$VCS_FOREGROUND_COLOR}${hook_com[branch]}%f"
    # Always show the remote
    #if [[ -n ${remote} ]] ; then
    # Only show the remote if it differs from the local
    if [[ -n ${remote} && ${remote#*/} != ${branch_name} ]] ; then
        hook_com[branch]+="%F{$VCS_FOREGROUND_COLOR}→%f%F{$VCS_FOREGROUND_COLOR}${remote// /}%f"
    fi
}

function +vi-git-tagname() {
    local tag

    tag=$(git describe --tags --exact-match HEAD 2>/dev/null)
    [[ -n ${tag} ]] && hook_com[branch]=" %F{$VCS_FOREGROUND_COLOR}${tag}%f"
}

# Show count of stashed changes
# Port from https://github.com/whiteinge/dotfiles/blob/5dfd08d30f7f2749cfc60bc55564c6ea239624d9/.zsh_shouse_prompt#L268
function +vi-git-stash() {
  local -a stashes

  if [[ -s $(git rev-parse --git-dir)/refs/stash ]] ; then
    stashes=$(git stash list 2>/dev/null | wc -l)
    hook_com[misc]+=" %F{$VCS_FOREGROUND_COLOR}⍟${stashes// /}%f"
  fi
}

function +vi-hg-bookmarks() {
  if [[ -n "${hgbmarks[@]}" ]]; then
    hook_com[hg-bookmark-string]=" ☿ ${hgbmarks[@]}"

    # And to signal, that we want to use the sting we just generated,
    # set the special variable `ret' to something other than the default
    # zero:
    ret=1
    return 0
  fi
}

function +vi-vcs-detect-changes() {
  if [[ -n ${hook_com[staged]} ]] || [[ -n ${hook_com[unstaged]} ]]; then
    VCS_WORKDIR_DIRTY=true
  else
    VCS_WORKDIR_DIRTY=false
  fi
}

################################################################
# Prompt Segments
################################################################

# Context: user (who am I and where am I)
# Note that if $DEFAULT_USER is not set, this prompt segment will always print
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    # $1_prompt_segment $0 $DEFAULT_COLOR "011" "%(!.%{%F{yellow}%}.)$USER"
    $1_prompt_segment $0 yellow $DEFAULT_COLOR "%(!.%{%F{red}%}.)$USER"
  fi
}

# Dir: current working directory
prompt_dir() {
  $1_prompt_segment $0 blue $DEFAULT_COLOR '%c'
}

# Command number (in local history)
prompt_history() {
  $1_prompt_segment $0 "244" $DEFAULT_COLOR '%h'
}

# Right Status: (return code, root status, background jobs)
# This creates a status segment for the *right* prompt. Exact same thing as
# above - just other side.
prompt_longstatus() {
  local symbols bg
  symbols=()

  if [[ $RETVAL -ne 0 ]]; then
    symbols+="%{%F{"226"}%}%? ↵"
    bg="009"
  else
    symbols+="%{%F{"046"}%}✓"
    bg="008"
  fi

  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && $1_prompt_segment $0 $bg $DEFAULT_COLOR "$symbols"
}

# Left Status: (return code, root status, background jobs)
# This creates a status segment for the *left* prompt
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && $1_prompt_segment $0 $DEFAULT_COLOR default "$symbols"
}

# Show a ratio of tests vs code
build_test_stats() {
  local code_amount=$3
  local tests_amount=$4+0.00001
  local headline=$5

  # Set float precision to 2 digits:
  typeset -F 2 ratio
  local ratio=$(( (tests_amount/code_amount) * 100 ))

  [[ ratio -ge 0.75 ]] && $1_prompt_segment ${2}_GOOD cyan $DEFAULT_COLOR "$headline: $ratio%%"
  [[ ratio -ge 0.5 && ratio -lt 0.75 ]] && $1_prompt_segment $2_AVG yellow $DEFAULT_COLOR "$headline: $ratio%%"
  [[ ratio -lt 0.5 ]] && $1_prompt_segment $2_BAD red $DEFAULT_COLOR "$headline: $ratio%%"
}

# System time
prompt_time() {
  local time_format='%D{%H:%M:%S}'
  if [[ -n $HYDAI_TIME_FORMAT ]]; then
    time_format=$HYDAI_TIME_FORMAT
  fi

  $1_prompt_segment $0 $DEFAULT_COLOR_INVERTED $DEFAULT_COLOR "$time_format "
}

################################################################
# Prompt processing and drawing
################################################################

# Main prompt
build_left_prompt() {
  if [[ ${#HYDAI_LEFT_PROMPT_ELEMENTS} == 0 ]]; then
    HYDAI_LEFT_PROMPT_ELEMENTS=(context dir vcs)
  fi

  for element in $HYDAI_LEFT_PROMPT_ELEMENTS; do
    prompt_$element "left"
  done

  left_prompt_end
}

# Right prompt
build_right_prompt() {
  RETVAL=$?

  if [[ ${#HYDAI_RIGHT_PROMPT_ELEMENTS} == 0 ]]; then
    HYDAI_RIGHT_PROMPT_ELEMENTS=(longstatus history time)
  fi

  for element in $HYDAI_RIGHT_PROMPT_ELEMENTS; do
    prompt_$element "right"
  done
}

precmd() {
  vcs_info

  # Add a static hook to examine staged/unstaged changes.
  vcs_info_hookadd set-message vcs-detect-changes
}

if [[ "$HYDAI_PROMPT_ON_NEWLINE" == true ]]; then
  PROMPT='╭─%{%f%b%k%}$(build_left_prompt) 
╰─○ '
else
  PROMPT='%{%f%b%k%}$(build_left_prompt) '
fi
RPROMPT='%{%f%b%k%}$(build_right_prompt)%{$reset_color%}'

