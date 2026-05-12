function infra --description 'infra wrapper that refreshes kube prompt cache'
    command infra $argv
    and _kube_cache_update
end
