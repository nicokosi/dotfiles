echo "Set git user.email to \"nicolas.kosinski@vidal.fr\" for all repos in ~/work/vidal"
vidal_folder="/Users/nicolas/work/vidal"
vidal_repos=`find $vidal_folder -maxdepth 1 -type d -print | grep --invert-match "\.$"`
for folder in $vidal_repos ; do cd $folder ; echo $folder ; git config user.email "nicolas.kosinski@vidal.fr" ; done

echo "Done!\n"
echo "Check:"
for folder in $vidal_repos ; do cd $folder ; echo $folder ; git config --local --get user.email ; done
