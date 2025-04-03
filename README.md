# HSAPI
Prototype for HSAPI in Swift

Currently just implements parsing to high-level objects.

Low level data structures are both deserializable and serializable

## TODO
* Implement serialization from high level structures
* Implement iterators for blocks, scenes, etc.
* Figure out what api will be exposed – don't want raw access to just doing i.e. `project.blocks.append(newBlock)` – might want to control what happens then
* Resolve referenced ids when used