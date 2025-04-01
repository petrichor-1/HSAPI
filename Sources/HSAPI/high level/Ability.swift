import Foundation

class Ability {
	var id: String
	var blocks = [Block]()
	var createdAt: Date

	weak var project: Project?

	init(id: String, blocks: [Block] = [Block](), createdAt: Date, project: Project) {
		self.id = id
		self.blocks = blocks
		self.createdAt = createdAt
		self.project = project
	}

	func addBlock(_ block: Block) {
		blocks.append(block)
	}
}

extension Ability {
	convenience init(from lowLevel: LowLevelAbility, project: Project) {
		let id = lowLevel.abilityID ?? Ability.generateID()
		var createdAt = Ability.creationEpoch
		if let lowLevelCreatedAt = lowLevel.createdAt {
			createdAt = Date(timeInterval: lowLevelCreatedAt, since: Ability.creationEpoch)
		}
		self.init(id: id, createdAt: createdAt, project: project)
		
		guard let lowLevelBlocks = lowLevel.blocks else {
			return
		}
		for lowLevelBlock in lowLevelBlocks {
			addBlock(Block(from: lowLevelBlock, project: project))
		}
	}

	private static func generateID() -> String {
		fatalError("TODO: Ability.generateID")
	}

	private static let creationEpoch = try! Date("2001-01-01T00:00:00Z", strategy: .iso8601)
}