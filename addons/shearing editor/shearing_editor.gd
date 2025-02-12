tool
extends EditorPlugin
# TODO resetleme butonu snapping on off ve snap limiti 
var eds = get_editor_interface().get_selection()
var _button= preload("res://addons/shearing editor/shearing_button.tscn")
var asd 
var switch = true
var editObject
var isVisible =false
var is2D=false
var isShaderRight=false
var shaderCords =[]
var isMatRight=false

var cordDragIndex=-1
var lifted=false
var dragPos =Vector2.ZERO
var cordViewPos =[]
var isCanvasItem = false
var isTextureRect=false
var shader_name=""


func check2D(tab_name):
	if tab_name =="2D":
		is2D=true

func _ready():
	connect("main_screen_changed", self, "check2D")


func down():
	if switch:
		switch=false
		update_overlays()
		return
	
	if editObject is TextureRect or editObject is Sprite:
		if editObject.texture ==null:
			error(1)
			switch = false
			return
	if editObject is Button:
		if editObject.icon ==null:
			error(1)
			switch = false
			return
	if editObject.has_method("get_material") ==false:
		switch = false
		return
	if editObject.material ==null:
		error(2)
		switch = false
		return
	else:
		if editObject.material.shader.has_param("shader_param/topleft") == false:
			error(0)
			return
		print("It is OK to skew")
		switch = true
	update_overlays()


func _process(delta):
	if switch:
		if editObject != null:
			if editObject.material !=null:
				if editObject.material.get_shader_param("topleft") ==null:
					isMatRight=false
				else:
					shaderCords.clear()
					
					var trans_view = editObject.get_viewport_transform()
					var trans_glob = editObject.get_global_transform()
					var texture_size
					
					#if you want another canvasitem you should check here
					if editObject is TextureRect:
						if  editObject.texture==null:
							return
						texture_size = editObject.texture.get_size()/2
						isTextureRect=true
						isCanvasItem=false
					elif editObject  is CanvasItem and not editObject  is Sprite:
						if  editObject.icon==null:
							return
						texture_size = editObject.icon.get_size()/2
						isCanvasItem=true
						isTextureRect=false
					else:
						if  editObject.texture==null:
							return
						isCanvasItem=false
						isTextureRect=false
						texture_size = editObject.texture.get_size()/2
					
					if isTextureRect:
						var _pos = (trans_view * trans_glob).translated(2*texture_size+editObject.material.get_shader_param("bottomright")).origin
						shaderCords.append(_pos)
						
						_pos = (trans_view * trans_glob).translated( editObject.material.get_shader_param("topleft")).origin
						shaderCords.append(_pos)
						
						var oldx = texture_size.x
						texture_size.x = 0
						texture_size.y = texture_size.y*2
						_pos = (trans_view * trans_glob).translated(texture_size + editObject.material.get_shader_param("bottomleft")).origin
						shaderCords.append(_pos)
						
						texture_size.x = oldx *2
						texture_size.y=0
						_pos = (trans_view * trans_glob).translated(texture_size + editObject.material.get_shader_param("topright")).origin
						
						shaderCords.append(_pos)
					elif not isCanvasItem:
						var _pos = (trans_view * trans_glob).translated(texture_size+editObject.material.get_shader_param("bottomright")).origin
						shaderCords.append(_pos)
						
						_pos = (trans_view * trans_glob).translated(-texture_size + editObject.material.get_shader_param("topleft")).origin
						shaderCords.append(_pos)
						
						texture_size.x = -texture_size.x
						_pos = (trans_view * trans_glob).translated(texture_size + editObject.material.get_shader_param("bottomleft")).origin
						shaderCords.append(_pos)
						
						texture_size.x = -texture_size.x
						texture_size.y = -texture_size.y
						_pos = (trans_view * trans_glob).translated(texture_size + editObject.material.get_shader_param("topright")).origin
						
						shaderCords.append(_pos)
					else:
						var _pos = (trans_view * trans_glob).translated(2*texture_size+editObject.material.get_shader_param("bottomright")).origin
						shaderCords.append(_pos)
						
						_pos = (trans_view * trans_glob).translated( editObject.material.get_shader_param("topleft")).origin
						shaderCords.append(_pos)
						
						var oldx = texture_size.x
						texture_size.x = 0
						texture_size.y = texture_size.y*2
						_pos = (trans_view * trans_glob).translated(texture_size + editObject.material.get_shader_param("bottomleft")).origin
						shaderCords.append(_pos)
						
						texture_size.x = oldx *2
						texture_size.y=0
						_pos = (trans_view * trans_glob).translated(texture_size + editObject.material.get_shader_param("topright")).origin
						
						shaderCords.append(_pos)
					
					isMatRight=true
					update_overlays()
			else:
				isMatRight=false

func forward_canvas_draw_over_viewport(overlay):
	if editObject:
		if switch:
			if isMatRight:
				for pos in shaderCords:
					
					overlay.draw_circle(pos, 10, Color(0.8,0.1,0.7))

func forward_canvas_gui_input(event):
	if event is InputEventMouseButton and not event.pressed:
		if event.button_index == BUTTON_LEFT:
			lifted = false

	if lifted and event is InputEventMouseMotion:
		var trans_view = editObject.get_viewport_transform()
		var trans_glob = editObject.get_global_transform()
		var pos 
		
		var texture_size
		#if you want another canvasitem you should check here
		if editObject  is CanvasItem and not editObject  is Sprite and not editObject is TextureRect:
			texture_size = editObject.icon.get_size()/2
		else:
			texture_size = editObject.texture.get_size()/2
		
		var uniformName="bottomright"
		if isTextureRect:
			if cordDragIndex==0:
				pos = trans_glob.translated(Vector2(2*texture_size.x,2*texture_size.y)).origin/trans_glob.get_scale()
				uniformName="bottomright"
			elif cordDragIndex==1:
				pos = trans_glob.origin/trans_glob.get_scale()
				uniformName="topleft"
			elif cordDragIndex==2:
				texture_size.x = -texture_size.x
				pos = trans_glob.translated(Vector2(0,2*texture_size.y)).origin/trans_glob.get_scale()
				uniformName="bottomleft"
			elif cordDragIndex==3:
				texture_size.y = -texture_size.y
				pos = trans_glob.translated(Vector2(2*texture_size.x,0)).origin/trans_glob.get_scale()
				uniformName="topright"
			elif cordDragIndex==-1:
				update_overlays()
				return
		elif isCanvasItem:
			if cordDragIndex==0:
				pos = trans_glob.translated(Vector2(2*texture_size.x,2*texture_size.y)).origin/trans_glob.get_scale()
				uniformName="bottomright"
			elif cordDragIndex==1:
				pos = trans_glob.origin/trans_glob.get_scale()
				uniformName="topleft"
			elif cordDragIndex==2:
				texture_size.x = -texture_size.x
				pos = trans_glob.translated(Vector2(0,2*texture_size.y)).origin/trans_glob.get_scale()
				uniformName="bottomleft"
			elif cordDragIndex==3:
				texture_size.y = -texture_size.y
				pos = trans_glob.translated(Vector2(2*texture_size.x,0)).origin/trans_glob.get_scale()
				uniformName="topright"
			elif cordDragIndex==-1:
				update_overlays()
				return
		else:
			if cordDragIndex==0:
				pos = trans_glob.translated(texture_size).origin/trans_glob.get_scale()
				uniformName="bottomright"
			elif cordDragIndex==1:
				pos = trans_glob.translated(-texture_size).origin/trans_glob.get_scale()
				uniformName="topleft"
			elif cordDragIndex==2:
				texture_size.x = -texture_size.x
				pos = trans_glob.translated(texture_size).origin/trans_glob.get_scale()
				uniformName="bottomleft"
			elif cordDragIndex==3:
				texture_size.y = -texture_size.y
				pos = trans_glob.translated(texture_size).origin/trans_glob.get_scale()
				uniformName="topright"
			elif cordDragIndex==-1:
				update_overlays()
				return
		
		var mouse_pos = editObject.get_global_mouse_position()/trans_glob.get_scale()
		var pos2 = mouse_pos-pos
		
		editObject.material.set_shader_param(uniformName,pos2)
		update_overlays()
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			lifted = true
			if editObject !=null:
				var i=0
				for pos in shaderCords:
					if event.position.distance_to(pos)<10.0:
						if switch:
							cordDragIndex= i
							return true
					else:
						cordDragIndex= -1
					i+=1

func edit(object):
	editObject = object

func handles(object):
	editObject = object
	switch = false
	return object


func create_button():
	asd = _button.instance()
	asd.connect("button_down",self,"down")
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU,asd)


func _enter_tree():
	create_button()


func make_visible(visible):
	isVisible=visible
	update_overlays()

func _exit_tree():
	asd.free()

func error(which):
	if which ==0:
		print("Material is wrong")
	elif which==1:
		print("There isn't a texture")
	elif which ==2:
		print("There isn't a material")