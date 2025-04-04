import Foundation

///Used to store information about the types of custom images available in the project.
/// Even in published projects, timestamps here contain the timezone information
struct LowLevelCustomObject {
	///When the image was added to the project
	var createdDate: String?
	///The filename of the image
	var fileName: String?
	///A unique id for this custom object
	var id: String?
	///The name of this image
	var name: String?
	///The dimensions of the image
	var size: LowLevelStageSize? //FIXME: What is this *ACTUALLY* supposed to be?
	///When the image was updated
	var updatedDate: String?

	/// Extra data. Will be overwritten by values in full regular properties when jsonified, if applicable
	var extraData = [String: JSONType?]()
}

extension LowLevelCustomObject: Codable {
	enum CodingKeys: String, CodingKey {
		case createdDate
		case fileName
		case id
		case name
		case size
		case updatedDate
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .createdDate: 
					if let createdDate = try? container.decode(String.self, forKey: key) {
						self.createdDate = createdDate
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .fileName: 
					if let fileName = try? container.decode(String.self, forKey: key) {
						self.fileName = fileName
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .id: 
					if let id = try? container.decode(String.self, forKey: key) {
						self.id = id
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .name: 
					if let name = try? container.decode(String.self, forKey: key) {
						self.name = name
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .size: 
					if let size = try? container.decode(LowLevelStageSize.self, forKey: key) {
						self.size = size
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .updatedDate: 
					if let updatedDate = try? container.decode(String.self, forKey: key) {
						self.updatedDate = updatedDate
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
		if let createdDate {
			try mainContainer.encodeIfPresent(createdDate, forKey: .createdDate)
		}
		if let fileName {
			try mainContainer.encodeIfPresent(fileName, forKey: .fileName)
		}
		if let id {
			try mainContainer.encodeIfPresent(id, forKey: .id)
		}
		if let name {
			try mainContainer.encodeIfPresent(name, forKey: .name)
		}
		if let size {
			try mainContainer.encodeIfPresent(size, forKey: .size)
		}
		// TODO: Should we imitate the app's encoding behavior here?
		if let updatedDate {
			try mainContainer.encodeIfPresent(updatedDate, forKey: .updatedDate)
		}
	}
}