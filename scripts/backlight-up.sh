current="$(xbacklight -get)"

xbacklight -inc $(echo "$current / 5 + 1" | bc)
