///A hopscotch object definition
struct LowLevelObject {
	///The width of the object
	var width: String?
	///The height of the object
	var height: String?
	///The name of the object
	var name: String?
	///The scale this object was resized to by pinching it
	///   Should be a number, though it is represented as a string.
	var resizeScale: String?
	///The filename of a png containing the object.
	/// Not sure what this does. It is usually “object name.png” (for example, “text-object.png”)
	/// needs to be correct or the editor will not understand it and replace the object with a monkey.
	/// Custom images use “image.png”. To find the correct filename for any id, the easiest way is to create a set image block for it, open it in the Hopscotch editor, then check the block’s datum after saving it.
	var filename: String?
	///The id of the ability for the before game starts rule
	/// Only set variable or comment blocks are accesible to put there in the editor, though any block will work if it is in the ability, and it will run.
	/// It only runs the first frame’s worth of code
	var abilityID: String?
	///An array of ids of rules or custom rule instances
	var rules: [String]?
	var xPosition: String?
	var yPosition: String?
	///The unique id for this object
	var objectID: String?
	///The type of this object
	var type: Double?
	///The text content of the object.
	/// The iOS editor puts it there for every object, even those that are not text objects.
	/// Can be omitted
	var text: String?
	///The id of the image this object is
	/// Only present on custom image objects
	var customObjectID: String?
	///How much this was rotated in the editor
	var rotation: String?

	/// Extra data. Will be overwritten by values in full regular properties when jsonified, if applicable
	var extraData = [String: JSONType]()
}

extension LowLevelObject: Codable {
	enum CodingKeys: CodingKey {
		case width
		case height
		case name
		case resizeScale
		case filename
		case abilityID
		case rules
		case xPosition
		case yPosition
		case objectID
		case type
		case text
		case customObjectID
		case rotation
	}

	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .width:
					if let width = try? container.decode(String.self, forKey: key) {
						self.width = width
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .height:
					if let height = try? container.decode(String.self, forKey: key) {
						self.height = height
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .name:
					if let name = try? container.decode(String.self, forKey: key) {
						self.name = name
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .resizeScale:
					if let resizeScale = try? container.decode(String.self, forKey: key) {
						self.resizeScale = resizeScale
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .filename:
					if let filename = try? container.decode(String.self, forKey: key) {
						self.filename = filename
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .abilityID:
					if let abilityID = try? container.decode(String.self, forKey: key) {
						self.abilityID = abilityID
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .rules:
					if let rules = try? container.decode([String].self, forKey: key) {
						self.rules = rules
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .xPosition:
					if let xPosition = try? container.decode(String.self, forKey: key) {
						self.xPosition = xPosition
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .yPosition:
					if let yPosition = try? container.decode(String.self, forKey: key) {
						self.yPosition = yPosition
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .objectID:
					if let objectID = try? container.decode(String.self, forKey: key) {
						self.objectID = objectID
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .type:
					if let type = try? container.decode(Double.self, forKey: key) {
						self.type = type
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .text:
					if let text = try? container.decode(String.self, forKey: key) {
						self.text = text
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .customObjectID:
					if let customObjectID = try? container.decode(String.self, forKey: key) {
						self.customObjectID = customObjectID
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .rotation:
					if let rotation = try? container.decode(String.self, forKey: key) {
						self.rotation = rotation
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				}
                continue
            }

            let value = try container.decode(JSONType.self, forKey: key)
            extraData[key.stringValue] = value
        }
    }

	func encode(to encoder: Encoder) throws {
		var extraDataContainer = encoder.container(keyedBy: ArbitraryStringCodingKeys.self)
		for (key, value) in extraData {
			try extraDataContainer.encode(value, forKey: ArbitraryStringCodingKeys(stringValue: key))
		}
		var mainContainer = encoder.container(keyedBy: CodingKeys.self)
		if let width {
			try mainContainer.encode(width, forKey: .width)
		}
		if let height {
			try mainContainer.encode(height, forKey: .height)
		}
		if let name {
			try mainContainer.encode(name, forKey: .name)
		}
		if let resizeScale {
			try mainContainer.encode(resizeScale, forKey: .resizeScale)
		}
		if let filename {
			try mainContainer.encode(filename, forKey: .filename)
		}
		if let abilityID {
			try mainContainer.encode(abilityID, forKey: .abilityID)
		}
		if let rules {
			try mainContainer.encode(rules, forKey: .rules)
		}
		if let xPosition {
			try mainContainer.encode(xPosition, forKey: .xPosition)
		}
		if let yPosition {
			try mainContainer.encode(yPosition, forKey: .yPosition)
		}
		if let objectID {
			try mainContainer.encode(objectID, forKey: .objectID)
		}
		if let type {
			try mainContainer.encode(type, forKey: .type)
		}
		if let text {
			try mainContainer.encode(text, forKey: .text)
		}
		if let customObjectID {
			try mainContainer.encode(customObjectID, forKey: .customObjectID)
		}
		if let rotation {
			try mainContainer.encode(rotation, forKey: .rotation)
		}
	}
}