// NotificationService.swift
import UserNotifications
import Intents

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else { return }
        
        // Handle image
        if let imageUrlString = bestAttemptContent.userInfo["image-url"] as? String,
           let imageUrl = URL(string: imageUrlString) {
            downloadAndAttachImage(url: imageUrl) { attachment in
                if let attachment = attachment {
                    bestAttemptContent.attachments = [attachment]
                }
                
                // Handle sender avatar (icon)
                if let senderDict = bestAttemptContent.userInfo["sender"] as? [String: Any],
                   let avatarUrlString = senderDict["avatar-url"] as? String,
                   let avatarUrl = URL(string: avatarUrlString) {
                    self.downloadAndAttachAvatar(url: avatarUrl) { avatarData in
                        if let avatarData = avatarData {
                            let intent = INSendMessageIntent(
                                recipients: nil,
                                outgoingMessageType: .outgoingMessageText,
                                content: bestAttemptContent.body,
                                speakableGroupName: nil,
                                conversationIdentifier: "communication-thread",
                                serviceName: nil,
                                sender: INPerson(
                                    personHandle: INPersonHandle(value: "user123", type: .unknown),
                                    nameComponents: nil,
                                    displayName: senderDict["name"] as? String,
                                    image: INImage(imageData: avatarData),
                                    contactIdentifier: nil,
                                    customIdentifier: nil
                                ),
                                attachments: nil
                            )
                            bestAttemptContent.threadIdentifier = "communication-thread"
                            let interaction = INInteraction(intent: intent, response: nil)
                            interaction.donate { error in
                                if let error = error { print("Donation error: \(error)") }
                                contentHandler(bestAttemptContent)
                            }
                        } else {
                            contentHandler(bestAttemptContent)
                        }
                    }
                } else {
                    contentHandler(bestAttemptContent)
                }
            }
        } else {
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func downloadAndAttachImage(url: URL, completion: @escaping (UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            _ = FileManager.default
            let tempDirectory = NSTemporaryDirectory()
            let fileName = UUID().uuidString + ".jpg"
            let fileURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(fileName)
            
            do {
                try data.write(to: fileURL)
                let attachment = try UNNotificationAttachment(identifier: fileName, url: fileURL, options: nil)
                completion(attachment)
            } catch {
                print("Error creating attachment: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    private func downloadAndAttachAvatar(url: URL, completion: @escaping (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(data)
        }
        task.resume()
    }
}
