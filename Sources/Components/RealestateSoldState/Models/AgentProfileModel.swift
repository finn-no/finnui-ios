import Foundation

public struct AgentProfileModel {
    public let title: String
    public let agentName: String
    public let agentJobTitle: String
    public let imageUrl: String?
    public let phoneNumber: String?

    public init(title: String, agentName: String, agentJobTitle: String, imageUrl: String?, phoneNumber: String?) {
        self.title = title
        self.agentName = agentName
        self.agentJobTitle = agentJobTitle
        self.imageUrl = imageUrl
        self.phoneNumber = phoneNumber
    }
}
