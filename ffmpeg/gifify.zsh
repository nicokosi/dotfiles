#!/bin/zsh

gifify() {
    if [ $# -lt 1 ] ; then
        echo "Transforms a video into an animated GIF. 🎬
Usage:
    $0 input output rate
        input: path of the input video file (mandatory)
        output: path of the output animatif gif file (optional, default is 'output.gif')
        rate: rate per second (optional, default is 4)"
    else
        ffmpeg -i $1 -r ${3:-4} ${2:-output.gif}
    fi
}
