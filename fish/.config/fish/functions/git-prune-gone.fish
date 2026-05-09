function git-prune-gone --description "Delete local branches that have been deleted on remote"
    git fetch -p
    or return

    set -l gone (git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == "[gone]" {print $1}')
    test -n "$gone"; and git branch -D $gone
end
