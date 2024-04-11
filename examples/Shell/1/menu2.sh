#!/bin/bash
function menu(){
    case $1 in
    one)
    echo "Hello World!"
        ;;
    two)
    echo "Hello Two"
        ;;
    *)
    echo "invalid option!"
esac   
}
if [[ "$#" -eq 1 ]]; then
#if [[ "$#" -eq 1 ]]; then
    menu $1
else
    echo "Command Format:"
    echo "bash menuoption.sh one|two"
fi