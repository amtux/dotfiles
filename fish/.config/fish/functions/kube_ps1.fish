function kube_ps1 --description 'Read cached kube context:namespace for prompt'
    set -l cache /tmp/kube-ps1-(id -u)
    test -r $cache; or return

    set -l text (cat $cache)
    switch $text
        case '*prd-*' '*prod-*'  ; set_color f38ba8  # mocha red
        case '*stg-*' '*stage-*' ; set_color fab387  # mocha peach
        case '*dev-*'            ; set_color a6e3a1  # mocha green
        case '*'                 ; set_color 89b4fa  # mocha blue
    end
    echo -n $text
    set_color normal
end
