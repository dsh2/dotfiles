
var state = 0

var commands = [
	'j',
	'show-progress',
	'show-clock'
]

function perform_action() {
	mp.command(commands[state])
	state = (state + 1) % commands.length
}

mp.add_key_binding('i', 'your-multiple-action', perform_action)
