class Scene {
	var thumbnailFilename: String? = nil
	var name: String
	var id: String
	var objects = [ObjectID]()

	weak var project: Project?

	init(thumbnailFilename: String? = nil, name: String, id: String, objects: [ObjectID] = [ObjectID](), project: Project) {
		self.thumbnailFilename = thumbnailFilename
		self.name = name
		self.id = id
		self.objects = objects
		self.project = project
	}

	func addObject(_ id: ObjectID) {
		objects.append(id)
	}
}

extension Scene {
	convenience init(from lowLevel: LowLevelScene, project: Project) {
		//FIXME: nils
		let thumbnailFilename = lowLevel.filename
		let name = lowLevel.name ?? "HSAPI Unknown scene name"
		let id = lowLevel.id ?? "HSAPI unknown id"
		self.init(thumbnailFilename: thumbnailFilename, name: name, id: id, project: project)
		for objectID in lowLevel.objects ?? [] {
			addObject(.id(objectID))
		}
	}
}