extends CanvasLayer


@export var school_id: String



func _ready() -> void:
	get_viewport().transparent_bg = true
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().get_region(Rect2i(0, 0, 512, 512)).save_png("Data/Data/Images/Logos/Final/%s.png" % school_id)
