class_name ActionsMenu
extends Control

@onready var physical_attack_button:Button = $PanelContainer/VBoxContainer/Physical_Attack_Button
@onready var magic_attack_button:Button = $PanelContainer/VBoxContainer/Magic_Attack_Button
@onready var cover_button:Button = $PanelContainer/VBoxContainer/Cover_Button

func _process(delta):
	# print(visible)
	pass

func open_menu():
	visible = true

func close_menu():
	visible = false

func disable_menu():
	physical_attack_button.disabled = true
	magic_attack_button.disabled = true
	cover_button.disabled = true

func _on_physical_attack_button_button_down():
	CombatManager.btn_phys_attack_pressed()

func _on_magic_attack_button_button_down():
	CombatManager.btn_magic_attack_pressed()

func _on_cover_button_button_down():
	CombatManager.btn_cover_pressed()
