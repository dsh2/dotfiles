
function humanize(bytes) {
	units = "B KB MB GB TB PB"
	i = 0
	while (bytes >= 1024 && i < 5) {
		bytes /= 1024
		i++
	}
	return sprintf("%.1f %s", bytes, split(units, u) ? u[i+1] : "B")
}
