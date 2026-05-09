function kubectx --description 'Switch kube context and refresh prompt cache'
    command kubectx $argv
    and _kube_cache_update
end
