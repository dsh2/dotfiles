echo "Checking..."
if did_filetype()
  finish
endif
echo "Expanding..."
if expand("%:p") =~ '.*/Notizen/.*' | echo "Setting spelllang..." | set spelllang=de_20 | endif
echo "Done."
