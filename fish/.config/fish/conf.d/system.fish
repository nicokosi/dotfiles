# Temporarily switch to a minimal shell prompt
function minimalShellPrompt
    function fish_prompt
        echo '$ '
    end
    function fish_right_prompt
        echo ''
    end
end

# Kill the process listening on a given port
function netstop
    set pid (lsof -i :$argv[1] -t)
    if test -z "$pid"
        echo "This port is not used. Exiting..."
    else
        echo "Stopping pid $pid"
        kill -9 $pid
    end
end
