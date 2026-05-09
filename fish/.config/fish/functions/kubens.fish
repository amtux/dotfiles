function kubens --description 'Switch kube namespace and refresh prompt cache'
    command kubens $argv
    and _kube_cache_update
end
