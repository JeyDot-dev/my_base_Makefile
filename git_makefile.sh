#!/bin/bash
echo "Creating temp folder to save the Makefile  and the script to the git"
echo "Cloning git..."
git clone git@github.com:JeyDot-dev/my_base_Makefile ~/tmp_script_folder
cp Makefile ~/tmp_script_folder/Makefile
cp ~/scripts/git_makefile.sh ~/tmp_script_folder/git_makefile.sh
echo "Adding, Comitting and Pushing"
git -C ~/tmp_script_folder add Makefile git_makefile.sh
git -C ~/tmp_script_folder commit -m "Automated backup"
git -C ~/tmp_script_folder push
echo "Deleting temporary folder"
rm -rf ~/tmp_script_folder
echo "Done !"
