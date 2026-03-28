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

# Forward the SSH agent socket into a stable symlink so tmux sessions can still
# reach the agent after detaching and reattaching across different SSH connections.
if set -q SSH_AUTH_SOCK; and test "$SSH_AUTH_SOCK" != "$HOME/.ssh/agent.sock"
    ln -sf $SSH_AUTH_SOCK $HOME/.ssh/agent.sock
    set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.sock
end

# begin crisp completion
crisp --completion-fish | source
# end crisp completion
# crisp-cli
