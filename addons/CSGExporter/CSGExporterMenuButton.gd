tool
extends MenuButton

enum EXPORT_TYPE {OBJ}

var focused_csg_mesh : CSGShape
var file_dialog : FileDialog
var export_type

func _ready():
	get_popup().connect("index_pressed", self, "_on_popup_index_pressed")
	
	file_dialog = $FileDialog
	file_dialog.mode = FileDialog.MODE_SAVE_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.connect("file_selected", self, "_on_file_selected")

func _on_popup_index_pressed(id : int):
	if (id == 0):
		export_type = EXPORT_TYPE.OBJ
		file_dialog.show()

func _on_file_selected(path : String):
	if (export_type == EXPORT_TYPE.OBJ):
		_save_mesh_to_obj(path)

func _save_mesh_to_obj(path : String):
	var faces = focused_csg_mesh.get_meshes()[1].get_faces()
	
	var file = File.new()
	file.open(path, file.WRITE)
	
	for face in faces:
		print(face)
		var line = "v "
		for i in range(0,3):
			line += str(face[i]) + " "
		file.store_line(line)
	
	for i in range(len(faces)/3):
		file.store_line("f " + str(i*3+3) + " " + str(i*3+2) + " " + str(i*3+1))
	
	file.close()
