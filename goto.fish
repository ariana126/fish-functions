function goto --description 'Navigate to path shortcuts'
    set -l marks_dir ~/.goto

    if test (count $argv) -eq 0
        # List all available marks if no arguments given
        if not test -d $marks_dir
            echo "No goto shortcuts exist yet"
            echo "Create one with: goto NAME PATH"
            return 0
        end

        echo "Available goto shortcuts:"
        for mark in $marks_dir/*
            set -l mark_name (basename $mark)
            set -l mark_path (cat $mark)
            echo "  $mark_name -> $mark_path"
        end
    else if test (count $argv) -eq 1
        # If one argument, try to cd to that mark
        if not test -d $marks_dir
            echo "Error: ~/.goto directory doesn't exist"
            echo "Create it first with: mkdir -p ~/.goto"
            return 1
        end

        set -l mark_file $marks_dir/$argv[1]
        if test -f $mark_file
            cd (cat $mark_file)
        else
            echo "No goto shortcut named '$argv[1]'"
            echo "Available shortcuts:"
            goto
            return 1
        end
    else if test (count $argv) -eq 2
        # If two arguments, create a new mark
        if not test -d $marks_dir
            echo "Error: ~/.goto directory doesn't exist"
            echo "Create it first with: mkdir -p ~/.goto"
            return 1
        end

        set -l mark_name $argv[1]
        set -l target_path $argv[2]
        
        # Expand ~ and variables in the path
        set target_path (eval echo $target_path)
        
        # Convert to absolute path
        if not string match -q '/*' $target_path
            if test -d $target_path
                set target_path (realpath $target_path)
            else
                echo "Warning: Path '$target_path' doesn't exist"
            end
        end
        
        echo $target_path > $marks_dir/$mark_name
        echo "Created goto shortcut '$mark_name' -> '$target_path'"
    else
        echo "Usage:"
        echo "  goto - list all shortcuts"
        echo "  goto NAME - cd to shortcut NAME"
        echo "  goto NAME PATH - create new shortcut NAME for PATH"
        return 1
    end
end