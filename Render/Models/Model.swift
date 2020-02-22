import Foundation
import CloudKit

class Model {
  // MARK: - iCloud Info
  let container: CKContainer
  let publicDB: CKDatabase
  let privateDB: CKDatabase
  
  // MARK: - Properties
  private(set) var renders: [Render] = []
  static var currentModel = Model()
  
  init() {
    container = CKContainer.default()
    publicDB = container.publicCloudDatabase
    privateDB = container.privateCloudDatabase
  }
  
  @objc func refresh(_ completion: @escaping (Error?) -> Void) {
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Render", predicate: predicate)
    renders(forQuery: query, completion)
  }

  
  private func renders(forQuery query: CKQuery, _ completion: @escaping (Error?) -> Void) {
    publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
      guard let self = self else { return }
      if let error = error {
        DispatchQueue.main.async {
          completion(error)
        }
        return
      }
      guard let results = results else { return }
      self.renders = results.compactMap {
        Render(record: $0, database: self.publicDB)
      }
      DispatchQueue.main.async {
        completion(nil)
      }
    }
  }
}
