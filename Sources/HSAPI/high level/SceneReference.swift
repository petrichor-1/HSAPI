class SceneReference {
	var id: String
	var blockType: BlockType
	var description: String
	var scene: SceneID?

	weak var project: Project?

	init(id: String, blockType: BlockType, description: String, scene: SceneID? = nil, project: Project) {
		self.id = id
		self.blockType = blockType
		self.description = description
		self.scene = scene
		self.project = project
	}
}

extension SceneReference {
	convenience init(from lowLevelSceneReference: LowLevelSceneReference, project: Project) {
		// TODO: Handle nil values properly
		let id = lowLevelSceneReference.id ?? "HSAPI UNKNOWN SCENE REFERENCE ID TODO REMOVE THIS"
		let blockType = BlockType(doubleValue: lowLevelSceneReference.blockType ?? 22)
		let description = lowLevelSceneReference.description ?? blockType.description ?? "HSAPI UNKNOWN"
		let scene: SceneID? = if let id = lowLevelSceneReference.scene { .unknown(id: id) } else { nil }

		self.init(id: id, blockType: blockType, description: description, scene: scene, project: project)
	}
}