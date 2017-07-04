echo "Set git user.email to \"nicolas.kosinski@vidal.fr\" for all repos in ~/work/vidal"
vidal_folder="/Users/nicolas/work/vidal"
vidal_repos=`find $vidal_folder -maxdepth 1 -type d -print | grep --invert-match "\.$"`
for folder in $vidal_repos
do
  if [[ ( -d $folder && -d $folder/.git ) ]]; then
    cd $folder
    echo "\n$folder"
    git config user.email "nicolas.kosinski@vidal.fr"
    git config --local --get user.email
  fi
done

