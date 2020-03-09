//
//  Codables.swift
//  SAuthLib
//
//  Created by Kyle Jessup on 2018-03-22.
//

import Foundation
import PerfectNIO

public struct EmptyReply: Codable {
	public init() {}
}

public struct HealthCheckResponse: Codable {
	public let health: String
	public init(health h: String) {
		health = h
	}
}

public struct AccessToken: Codable {
	public let aliasId: String
	public let provider: String
	public let token: String
	public let expiration: Int?
	public init(aliasId: String,
				provider: String,
				token: String,
				expiration: Int?) {
		self.aliasId = aliasId
		self.provider = provider
		self.token = token
		self.expiration = expiration
	}
}

public struct SAuthError: Error, Codable, CustomStringConvertible {
	public let description: String
	public init(description d: String) {
		description = d
	}
}

public enum AuthAPI {
	public struct TokenAcquiredResponse<C: Codable>: Codable {
		public let token: String
		public let account: Account<C>?
		public init(token: String, account: Account<C>?) {
			self.token = token
			self.account = account
		}
	}
	
	public struct RegisterRequest<C: Codable>: Codable {
		public let email: String
		public let password: String
		public let profilePic: String?
		public let meta: C?
		public init(email e: String, password p: String, profilePic: String? = nil, meta m: C?) {
			email = e
			password = p
			self.profilePic = profilePic
			meta = m
		}
	}
	
	public struct LoginRequest: Codable {
		public let email: String
		public let password: String
		public init(email e: String, password p: String) {
			email = e
			password = p
		}
	}
	public struct AddMobileDeviceRequest: Codable {
		public let deviceId: String
		public let deviceType: String
		public init(deviceId: String, deviceType: String) {
			self.deviceId = deviceId
			self.deviceType = deviceType
		}
	}
	
	public struct PasswordResetRequest: Codable {
		public let address: String
		public let deviceId: String?
		public init(address: String, deviceId: String?) {
			self.address = address
			self.deviceId = deviceId
		}
	}
	
	public struct PasswordResetCompleteRequest: Codable {
		public let address: String
		public let password: String
		public let authToken: String
		public init(address: String, password: String, authToken: String) {
			self.address = address
			self.password = password
			self.authToken = authToken
		}
	}
}

public typealias TokenAcquiredResponse = AuthAPI.TokenAcquiredResponse

public struct TokenClaim {
//	enum CodingKeys: String, CodingKey {
//		case issuer = "iss", subject = "sub", expiration = "exp",
//		issuedAt = "iat", accountId = "accountId",
//		oauthProvider = "oauthProvider", oauthAccessToken = "oauthAccessToken"
//	}
	public var issuer: String? { payload["iss"] as? String }
	public var subject: String? { payload["sub"] as? String }
	public var expiration: Int? { payload["exp"] as? Int }
	public var issuedAt: Int? { payload["iat"] as? Int }
	public var accountId: UUID? { payload["accountId"] as? UUID }
	public let payload: [String:Any]
	public init(fields: [String:Any]) {
		var fields = fields
		let accountId: UUID?
		if let acs = fields.removeValue(forKey: "accountId") as? String {
			accountId = UUID(uuidString: acs)
		} else {
			accountId = nil
		}
		self.init(issuer: fields.removeValue(forKey: "iss") as? String,
				  subject: fields.removeValue(forKey: "sub") as? String,
				  expiration: fields.removeValue(forKey: "exp") as? Int,
				  issuedAt: fields.removeValue(forKey: "iat") as? Int,
				  accountId: accountId,
				  extra: fields)
		
	}
	public init(issuer: String? = nil,
				subject: String? = nil,
				expiration: Int? = nil,
				issuedAt: Int? = nil,
				accountId: UUID? = nil,
				extra: [String:Any]? = nil) {
		var p = [String:Any]()
		if let v = issuer {
			p["iss"] = v
		}
		if let v = subject {
			p["sub"] = v
		}
		if let v = expiration {
			p["exp"] = v
		}
		if let v = issuedAt {
			p["iat"] = v
		}
		if let v = accountId?.uuidString {
			p["accountId"] = v
		}
		if let v = extra {
			p.merge(v, uniquingKeysWith: {$1})
		}
		payload = p
	}
}

public struct Account<AccountPublicMeta: Codable>: Codable {
	public let id: UUID
	public let flags: UInt
	public let createdAt: Int
	public let profilePic: String?
	public let meta: AccountPublicMeta?
	public init(id: UUID,
				flags: UInt,
				createdAt: Int,
				profilePic: String? = nil,
				meta: AccountPublicMeta? = nil) {
		self.id = id
		self.flags = flags
		self.createdAt = createdAt
		self.profilePic = profilePic
		self.meta = meta
	}
}

public struct Alias: Codable {
	public let address: String
	public let account: UUID
	public let priority: Int
	public let flags: UInt
	public let pwSalt: String?
	public let pwHash: String?
	public let defaultLocale: String?
	public init(address: String,
				account: UUID,
				priority: Int,
				flags: UInt,
				pwSalt: String?,
				pwHash: String?,
				defaultLocale: String?) {
		self.address = address
		self.account = account
		self.priority = priority
		self.flags = flags
		self.pwSalt = pwSalt
		self.pwHash = pwHash
		self.defaultLocale = defaultLocale
	}
}

public struct AliasBrief: Codable {
	public let address: String
	public let account: UUID
	public let priority: Int
	public let flags: UInt
	public let defaultLocale: String?
	public init(address: String,
				account: UUID,
				priority: Int,
				flags: UInt,
				defaultLocale: String?) {
		self.address = address
		self.account = account
		self.priority = priority
		self.flags = flags
		self.defaultLocale = defaultLocale
	}
}

public struct Audit: Codable {
	public let alias: String
	public let action: String
	public let account: UUID?
	public let provider: String?
	public let error: String?
	public let attemptedAt: Int
	public init(alias: String,
				action: String,
				account: UUID?,
				provider: String?,
				error: String?,
				attemptedAt: Int) {
		self.alias = alias
		self.action = action
		self.account = account
		self.provider = provider
		self.error = error
		self.attemptedAt = attemptedAt
	}
}

public struct MobileDeviceId: Codable {
	public let deviceId: String
	public let deviceType: String
	public let aliasId: String
	public let createdAt: Int
	public init(deviceId: String, deviceType: String, aliasId: String, createdAt: Int) {
		self.deviceId = deviceId
		self.deviceType = deviceType
		self.aliasId = aliasId
		self.createdAt = createdAt
	}
}

public struct PasswordResetToken: Codable {
	public let aliasId: String
	public let authId: String
	public let expiration: Int
	public init(aliasId: String, authId: String, expiration: Int) {
		self.aliasId = aliasId
		self.authId = authId
		self.expiration = expiration
	}
}

public struct AccountValidationToken: Codable {
	public let aliasId: String
	public let authId: String
	public let createdAt: Int
	public init(aliasId: String, authId: String, createdAt: Int) {
		self.aliasId = aliasId
		self.authId = authId
		self.createdAt = createdAt
	}
}

public struct DeleteAccountRequest: Codable {
	public let accountId: UUID
	public init(accountId: UUID) {
		self.accountId = accountId
	}
}

public struct UpdateProfilePicResponse: Codable {
	public let profilePicURI: String?
	public init(profilePicURI: String?) {
		self.profilePicURI = profilePicURI
	}
}


public struct AccountRegisterRequest: Codable {
	public let email: String
	public let password: String
	public let isAdmin: Bool?
	public var fullName: String? = nil
	public var profilePic: FileUpload? = nil
	init(email: String, password: String, isAdmin: Bool) {
		self.email = email
		self.password = password
		self.isAdmin = isAdmin
	}
}

public struct UpdateProfilePicRequest: Codable {
	public let accountId: UUID
	public let profilePic: FileUpload
}
