# Plain Text journaling
# Input from Vim buffer
# @xallin - 2017-04-20 - v1.0

# STDIN = Vim buffer

STDIN=$(cat)

# Main Journal folder

DIR=TOBEDEFINED

# Date variables

DATE=$(date +%Y-%m-%d)
HOUR=$(date +%H)
MIN=$(date +%M)
NOW="$DATE"" ""$HOUR"":""$MIN"

# Create new entry as a single file in Journal folder
# The filename is formated as: aaaa-mm-dd~HHhMM.txt

NEW="$DIR""$DATE""~""$HOUR""h""$MIN"".txt"
touch "$NEW"
echo "$NOW"" ""$STDIN"$'\n' > "$NEW"
