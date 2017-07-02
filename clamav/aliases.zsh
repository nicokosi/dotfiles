alias antivirus-check='freshclam ; for folder in `find / -maxdepth 1 -type d -print | grep -v "^/$"` ; do clamscan -r --bell -i -r $folder ; echo "Analyzed folder $folder" ; done'
