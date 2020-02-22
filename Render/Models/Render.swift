import UIKit
import MapKit
import CloudKit
import CoreLocation

class Render {
  
  static let recordType = "Render"
  private let id: CKRecord.ID
  let renderName: String
  let coverPhoto: CKAsset?
  let shared: Bool
  let database: CKDatabase
  let allowedUsers: [String]
  let availableFrom: Date
  let closedAt: Date
  let openFrom: Date
  
  init?(record: CKRecord, database: CKDatabase) {
    guard
      let renderName = record["renderName"] as? String
      else { return nil }
    id = record.recordID
    self.renderName = renderName
    coverPhoto = record["coverPhoto"] as? CKAsset
    self.database = database
    self.shared = record["shared"] as? Bool ?? false
    self.allowedUsers = [""]
    self.availableFrom = record["availableFrom"] as? Date ?? Date()
    self.closedAt = record["availableFrom"] as? Date ?? Date()
    self.openFrom = record["availableFrom"] as? Date ?? Date()
  }
    
    func printInfo(){
        print(renderName, id, shared, database, allowedUsers, availableFrom, closedAt, openFrom)
    }
  
  func loadCoverPhoto(completion: @escaping (_ photo: UIImage?) -> ()) {
    DispatchQueue.global(qos: .utility).async {
      var image: UIImage?
      defer {
        DispatchQueue.main.async {
          completion(image)
        }
      }
      guard
        let coverPhoto = self.coverPhoto,
        let fileURL = coverPhoto.fileURL
        else {
          return
      }
      let imageData: Data
      do {
        imageData = try Data(contentsOf: fileURL)
      } catch {
        return
      }
      image = UIImage(data: imageData)
    }
  }
}

extension Render: Hashable {
  static func == (lhs: Render, rhs: Render) -> Bool {
    return lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
