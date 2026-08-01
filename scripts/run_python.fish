#!/usr/bin/env fish

# --- outer mode: spawn myself in a split and exit -------------
if test "$argv[1]" != "--inner"
    set file $argv[1]
    if test -z "$file"
        set file (pwd)/main.py
    end
    kitten @ launch --type=tab --cwd=current --tab-title "python $(basename $file)" \
    -- fish (status filename) --inner $file
    exit
end

# --- inner mode: the actual run -------------------------------
set file $argv[2]

set_color green
echo "Python "(basename $file)
set_color normal
echo

source ~/.config/pyenvs/env/bin/activate.fish
python $file
set st $status

echo
if test $st -eq 0
    set_color green; echo "End"
else
    set_color red; echo "Exit $st"
end
set_color normal

read -P ""
