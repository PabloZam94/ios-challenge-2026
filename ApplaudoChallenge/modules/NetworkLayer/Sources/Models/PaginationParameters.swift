//
//  PaginationParameters.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

// MARK: - Pagination Parameters
/// Query parameters for paginated endpoints. The Cat API uses zero-based pages.
struct PaginationParameters: Encodable {
    let page: Int
    let limit: Int
}
