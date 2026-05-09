function _kube_cache_update --description 'Refresh cached kube context:namespace'
    set -l cache /tmp/kube-ps1-(id -u)
    set -l ctx (command kubectl config current-context 2>/dev/null)
    or begin
        rm -f $cache
        return
    end
    set -l ns (command kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null)
    test -z "$ns"; and set ns default

    set ctx (string replace -r '^infra:' '' -- $ctx)

    printf "[⎈%s|%s]" $ctx $ns >$cache
end
