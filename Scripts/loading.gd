extends ColorRect
var dots = 1

func _process(delta):
	if dots == 1:
		await timer()
		$Label.set_text("Loading..")
		dots += 1
	elif dots == 2:
		await timer()
		$Label.set_text("Loading...")
		dots += 1
	elif dots > 2:
		await timer()
		$Label.set_text("Loading.")
		dots = 1

func timer():
	await get_tree().create_timer(1).timeout
