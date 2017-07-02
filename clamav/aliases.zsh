alias antivirus-check='freshclam ; for folder in `find / -maxdepth 1 -type d -print | grep -v "^/$"` ; do clamscan --bell --infected --recursive $folder ; echo "Analyzed folder $folder" ; done'
