# godot-project-template
A powerful, organized starting template to quickly begin a new Godot project.

This template includes a global event bus, scene manager, sound manager, and file loader to streamline common development tasks such as switching scenes, playing audio, loading resources, and broadcasting events between scripts.

## Getting Started:
### Clone & Import
1. Run command:
```bash
git clone https://github.com/kierangliver/godot-project-template.git
```
2. Open the godot launcher
3. Click **import**
4. Browse to the cloned folder.
5. Select the `project.godot` file to **Import & Edit**

## Autoload Singletons

Some scripts in this template are designed to be available globally. They are added to Autoload so they can be accessed anywhere in your project. These scripts are:

| Path                                     | Node Name     | Notes                           |
|------------------------------------------|---------------|---------------------------------|
| `res://Scripts/Autoload/event_bus.gd`    | *Event*       | Global Event System (pub/sub)   |
| `res://Scripts/Autoload/file_loader.gd`  | *FileLoader*  | Global file and resource loader |
| `res://Scripts/Autoload/save_manager.gd` | *SaveManager* | Global savefile system          |

You can access them anywhere:
```gdscript
Event.scene.switch.emit("main_menu")
var files = FileLoader.traverse_directory("res://Scenes")
```

## included Systems

### EventBus – Global Pub/Sub
* Lets you decouple game logic by emitting and listening for global signals
* Defines the scene and sound event groups.

Example: Switching a scene from anywhere:
```gdscript
Event.scene.switch.emit("level1")
```
Example: Playing a sound from anywhere:
```gdscript
Event.sound.play.emit("jump")
```
---
### FileLoader – File & Resource Utilities
* Recursively searches folders
* Instantiates and adds `PackedScenes`
* Creates and adds `AudioStreamPlayer`
  
Example – Get all files in a folder:
```gdscript
var scene_paths = FileLoader.traverse_directory("res://Scenes", false)
```
Example – Instantiate a scene:
```gdscript
FileLoader.instantiate("res://Scenes/MainMenu.tscn", self)
```
Example – Create an audio player:
```gdscript
var player = FileLoader.player("res://Audio/coin.ogg", self, -6.0)
player.play()
```
---
### Scene Manager
* Scans a folder for `.tscn` scenes
* Allows switching scenes via `Event.scene.switch`
---
### Sound Manager
* Scans a folder for audio files
* Plays, stops, and sets volume for sounds
* Listens to `Event.sound` signals
---
### Save Manager
* Global data dictionary for save data
* Saves data as a json in local files
* Load save files on system to data

Example - Reset save data:
```gdscript
SaveManager.reset()
```
Example - Save data:
```gdscript
SaveManager.data["value"] = 1
SaveManager.save_json()
```
Example - Load data:
```gdscript
SaveManager.load_json()
```
