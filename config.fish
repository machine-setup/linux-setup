# Enable 24-bit true color support for terminal applications
set -gx COLORTERM truecolor

# Preferred editor
set -gx EDITOR vim

# Disable Claude uploads on commit
set -x DISABLE_AI_SESSION_SYNC true

alias fishc="vim ~/.config/fish/config.fish"
alias fishs="source ~/.config/fish/config.fish"

alias amend="git commit --amend --no-edit"
alias review="git review"
alias cached="git diff --cached"
alias clean="git reset --hard; git clean -fd;"
alias master="git checkout master"
alias gst="git status"

alias tinker="./scripts/tinker.php"
alias x="./x.php"
alias lint="crisp t lint"

# Add user-local binaries to PATH
export PATH="$HOME/.local/bin:$PATH"

# E.g. `pop 1`
function pop
    git stash pop "stash@{$argv[1]}"
end

# E.g. `stash my-branch`
function stash
    git checkout -b $argv[1]
    git stash save $argv[1] --include-untracked
end

function slugify
    iconv -t ascii//TRANSLIT \
    | tr -d "'" \
    | sed -E 's/[^a-zA-Z0-9]+/-/g' \
    | sed -E 's/^-+|-+$//g' \
    | tr "[:upper:]" "[:lower:]"
end

function gitbc
    set -l COMMIT_MESSAGE $argv[1]
    set -l BRANCH_NAME (echo $COMMIT_MESSAGE | slugify)

    git checkout -b "$BRANCH_NAME"
    git commit -m "$COMMIT_MESSAGE"
end

# Default directory on shell start
if status is-interactive
    cd $HOME/crisp
end

# Fix SSH agent forwarding breaking after tmux reattach.
# Each SSH login gets a new SSH_AUTH_SOCK (sshd creates a fresh socket
# per connection), but tmux panes keep the old value from whenever
# they started. Fix: point everything at a stable symlink, and
# re-point it to the current real socket on every fresh login.
if set -q SSH_AUTH_SOCK
    and test "$SSH_AUTH_SOCK" != "$HOME/.ssh/ssh_auth_sock"
    # relink stable path to this connection's real socket
    ln -sf $SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock
end
# tmux panes reference this fixed path, so they auto-follow updates
set -x SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock

# Start/attach tmux session by default - must be after the above SSH_AUTH_SOCK update!
if status is-interactive
    if test -z "$TMUX"
        tmux attach -t 0 2>/dev/null; or tmux attach 2>/dev/null
    end
end

# begin crisp completion
crisp --completion-fish | source
# end crisp completion
# crisp-cli
