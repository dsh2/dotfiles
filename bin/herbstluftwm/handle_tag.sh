#!/usr/bin/env zsh
tag=$(herbstclient tag_status | tr \\t \\n | dmenu -p "Rename/merge tag:") || exit 0
if [[ "$tag]" =~ ^[-.:+#%!] ]]; then
    # merge
    old_tag=$(herbstclient get_attr tags.focus.name)
    herbstclient use ${tag:1}
    herbstclient merge_tag $old_tag
elif [[ "$tag]" =~ ^@ ]]; then
    # add
    herbstclient add ${tag:1}
    herbstclient use ${tag:1}
else
    # rename
    herbstclient rename $(herbstclient get_attr tags.focus.name) $tag
fi
