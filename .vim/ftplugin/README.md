Files here are settings that are loaded based on file-type.  These provide additional settings on top of the ones located under $VIMRUNTIME/ftplugin/.

Paste this into your shell, and see what's available:

    cd $(vim -X -e -c 'echo "ignored" | echo $VIMRUNTIME | q' | awk 'NR==2{sub(/\r\r$/,"");print}')/ftplugin/; ls
    
