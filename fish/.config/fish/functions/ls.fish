function ls --wraps eza --description 'eza -lha'
    if type -q eza
        eza -lha $argv
    else
        command ls $argv
    end
end
