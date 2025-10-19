extends Node
enum itemAffects {pingWait,playerSpeed,pingRandomness,hintCircles}

@onready var player=get_node('../Player')

const items={
	"Better clock":[
		"Halves time between radar pings",
		100,
		{itemAffects.pingWait:0.5}
	],
	
}

var currentItems:PackedStringArray=["Better clock"]
var boughtItems:PackedStringArray=[]

func _ready():
	$HBoxContainer/Stats/Money/Label.text=str(get_parent().money)
	$HBoxContainer/Stats/Label.text="Stage:"+str(get_parent().stageNum+1)
	updateShop()

func updateShop():
	for oldItem in %"Shop items".get_children():
		oldItem.queue_free()
	var itemNodes=[]
	for item in currentItems:
		var itemNode=preload("res://Scenes/shop_item.tscn").instantiate()
		itemNode.get_node("%Title").text=item
		itemNode.get_node("%Description").text=items[item][0]
		itemNode.get_node("%Price").text=str(items[item][1])
		itemNode.pressed.connect(shopItemPressed.bind(item))
		itemNodes.append(itemNode)
		%"Shop items".add_child(itemNode)
		itemNode.custom_minimum_size=itemNode.get_node("HBoxContainer").size
	#for i in range(len(items)):
		#if i>0:
			#items[i].focus_neighbor_top=items[i-1].get_path()
			#items[i].focus_previous=items[i-1].get_path()
		#items[i].focus_neighbor_bottom= ^'/root/main/Button' if i==len(items)-1 else items[i+1].get_path()
		#items[i].focus_next= ^'/root/main/Button' if i==len(items)-1 else items[i+1].get_path()
	#if len(items)>0:
		#get_node("../Button").focus_neighbor_top=items[-1].get_path()
		#get_node("../Button").focus_previous=items[-1].get_path()
		

func shopItemPressed(title:String):
	print(title)
	var item=items[title]
	if(get_parent().money >=item[1]):
		get_parent().money-=item[1]
		doItemAffects(title)
		#print(currentItems)
		#get_node('../Button').grab_focus.call_deferred()
		updateShop()

func doItemAffects(title:String)->void:
	for affect in items[title][2]:
		match affect:
			itemAffects.pingWait:
				player.get_node("Ring Timer").wait_time*=items[title][2][itemAffects.pingWait]
			itemAffects.playerSpeed:
				player.SPEED*=items[title][2][itemAffects.playerSpeed]
			itemAffects.pingRandomness:
				player.randomness*=items[title][2][itemAffects.playerSpeed]


func exit() -> void:
	print('exit shop')
	get_parent().loadNextStage()
