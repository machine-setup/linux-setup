# Preferred editor
set -gx EDITOR vim

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

# Start/attach tmux session by default
if status is-interactive
    if test -z "$TMUX"
        tmux attach -t 0 2>/dev/null; or tmux attach 2>/dev/null
    end
end

# Pulls the current SSH agent socket from tmux and updates the stable
# symlink. Safe to call at any time; no-ops if not inside tmux.
function refresh-ssh-agent
    if set -q TMUX
        # Ask tmux for the current agent socket path, suppress errors,
        # and strip the "SSH_AUTH_SOCK=" prefix to get the bare path.
        set tmux_output (tmux show-environment SSH_AUTH_SOCK 2>/dev/null)
        set new_socket (echo $tmux_output | string replace "SSH_AUTH_SOCK=" "")

        # Get the path the stable symlink currently points to.
        set current_socket (readlink $HOME/.ssh/agent.sock)

        # Only update if tmux reported a socket and it differs from the current one.
        if test -n "$new_socket" -a "$new_socket" != "$current_socket"
            echo "> Updating SSH agent socket"
            ln -sf $new_socket $HOME/.ssh/agent.sock
            set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.sock
        end
    end
end

# Wrapper around git that refreshes the SSH agent first.
# Ensures agent forwarding works immediately after tmux reattach
# without needing to manually refresh in every pane.
function git
    refresh-ssh-agent
    command git $argv
end

# begin crisp completion
crisp --completion-fish | source
# end crisp completion
# crisp-cli
