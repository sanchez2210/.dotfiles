current=$(xbacklight -get)

xbacklight -dec $(echo "$current / 5 + 1" | bc)
