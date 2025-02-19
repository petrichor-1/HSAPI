import Foundation

/// An object representing as close to the raw json of a Hopscotch project as we get
struct LowLevelProject {
	var baseObjectScale: Double?
	var editedAt: String?
	var fontSize: Double?
	var playerUpgrades: [LowLevelPlayerUpgrade]?
	var playerVersion: String?
	var requiresBetaEditor: Bool?
	var stageSize: LowLevelStageSize?
	var version: Int?
	var abilities: [LowLevelAbility]?
	var customObjects: [LowLevelCustomObject]?
	var customRuleInstances: [LowLevelCustomRuleInstance]?
	var eventParameters: [LowLevelEventParameter]?
	var rules: [LowLevelRule]?
	var scenes: [LowLevelScene]?
	var sceneReference: [LowLevelSceneReference]?
	var traits: [LowLevelTrait]?
	var variables: [LowLevelVariable]?
	//TODO: Community-based attributes

	var extraData = [String: JSONType]()
}

extension LowLevelProject: Codable {
	enum CodingKeys: String, CodingKey {
		case baseObjectScale = "baseObjectScale"
		case editedAt = "edited_at"
		case fontSize = "fontSize"
		case playerUpgrades = "playerUpgrades"
		case playerVersion = "playerVersion"
		case requiresBetaEditor = "requires_beta_editor"
		case stageSize = "stageSize"
		case version = "version"
		case abilities = "abilities"
		case customObjects = "customObjects"
		case customRuleInstances = "customRuleInstances"
		case eventParameters = "eventParameters"
		case rules = "rules"
		case scenes = "scenes"
		case sceneReference = "sceneReference"
		case traits = "traits"
		case variables = "variables"
	}
	
	init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArbitraryStringCodingKeys.self)
        for key in container.allKeys {
            if let knownKey = CodingKeys(stringValue: key.stringValue) { 
                switch knownKey {
				case .baseObjectScale:
					if let baseObjectScale = try? container.decode(Double.self, forKey: key) {
						self.baseObjectScale = baseObjectScale
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .editedAt:
					if let editedAt = try? container.decode(String.self, forKey: key) {
						self.editedAt = editedAt
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .fontSize:
					if let fontSize = try? container.decode(Double.self, forKey: key) {
						self.fontSize = fontSize
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .playerUpgrades:
					// key = from, value = to
					if let playerUpgrades = try? container.nestedContainer(keyedBy: ArbitraryStringCodingKeys.self, forKey: key) {
						var result = [LowLevelPlayerUpgrade]()
						for key in playerUpgrades.allKeys {
							// FIXME: This will give nil for nondecodable values, give LowLevelPlayerUpgrade extraData
							result.append(LowLevelPlayerUpgrade(from: key.stringValue, to: (try? playerUpgrades.decode(String.self, forKey: key)) ?? "HSAPI ERROR COULD NOT DECODE FIXME FIXME (this should not have been committed. UNQIUIREU UNIEUQ ERROR EMS)"))
						}
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .playerVersion:
					if let playerVersion = try? container.decode(String.self, forKey: key) {
						self.playerVersion = playerVersion
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .requiresBetaEditor:
					if let requiresBetaEditor = try? container.decode(Bool.self, forKey: key) {
						self.requiresBetaEditor = requiresBetaEditor
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .stageSize:
					if let stageSize = try? container.decode(LowLevelStageSize.self, forKey: key) {
						self.stageSize = stageSize
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .version:
					if let version = try? container.decode(Int.self, forKey: key) {
						self.version = version
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .abilities:
					if let abilities = try? container.decode([LowLevelAbility].self, forKey: key) {
						self.abilities = abilities
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .customObjects:
					if let customObjects = try? container.decode([LowLevelCustomObject].self, forKey: key) {
						self.customObjects = customObjects
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .customRuleInstances:
					if let customRuleInstances = try? container.decode([LowLevelCustomRuleInstance].self, forKey: key) {
						self.customRuleInstances = customRuleInstances
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .eventParameters:
					if let eventParameters = try? container.decode([LowLevelEventParameter].self, forKey: key) {
						self.eventParameters = eventParameters
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .rules:
					if let rules = try? container.decode([LowLevelRule].self, forKey: key) {
						self.rules = rules
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .scenes:
					if let scenes = try? container.decode([LowLevelScene].self, forKey: key) {
						self.scenes = scenes
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .sceneReference:
					if let sceneReference = try? container.decode([LowLevelSceneReference].self, forKey: key) {
						self.sceneReference = sceneReference
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .traits:
					if let traits = try? container.decode([LowLevelTrait].self, forKey: key) {
						self.traits = traits
					} else {
						extraData[key.stringValue] = try container.decode(JSONType.self, forKey: key)
					}
				case .variables:
					if let variables = try? container.decode([LowLevelVariable].self, forKey: key) {
						self.variables = variables
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
		if let baseObjectScale {
			try mainContainer.encode(baseObjectScale, forKey: .baseObjectScale)
		}
		//TODO: Should this match the app's behavior?
		if let editedAt {
			try mainContainer.encode(editedAt, forKey: .editedAt)
		}
		if let fontSize {
			try mainContainer.encode(fontSize, forKey: .fontSize)
		}
		if let playerVersion {
			try mainContainer.encode(playerVersion, forKey: .playerVersion)
		}
		if let requiresBetaEditor {
			try mainContainer.encode(requiresBetaEditor, forKey: .requiresBetaEditor)
		}
		if let stageSize {
			try mainContainer.encode(stageSize, forKey: .stageSize)
		}
		if let version {
			try mainContainer.encode(version, forKey: .version)
		}
		if let abilities {
			try mainContainer.encode(abilities, forKey: .abilities)
		}
		if let customObjects {
			try mainContainer.encode(customObjects, forKey: .customObjects)
		}
		if let customRuleInstances {
			try mainContainer.encode(customRuleInstances, forKey: .customRuleInstances)
		}
		if let eventParameters {
			try mainContainer.encode(eventParameters, forKey: .eventParameters)
		}
		if let rules {
			try mainContainer.encode(rules, forKey: .rules)
		}
		if let scenes {
			try mainContainer.encode(scenes, forKey: .scenes)
		}
		if let sceneReference {
			try mainContainer.encode(sceneReference, forKey: .sceneReference)
		}
		if let traits {
			try mainContainer.encode(traits, forKey: .traits)
		}
		if let variables {
			try mainContainer.encode(variables, forKey: .variables)
		}
		var playerUpgradesContainer = mainContainer.nestedContainer(keyedBy: ArbitraryStringCodingKeys.self, forKey: .playerUpgrades)
		if let playerUpgrades {
			for upgrade in playerUpgrades {
				try playerUpgradesContainer.encode(upgrade.to, forKey: ArbitraryStringCodingKeys(stringValue: upgrade.from))
			}
		}
	}
}