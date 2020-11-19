//
//  responseError.swift
//  SapoAdminIOS
//
//  Created by ThangTM-PC on 11/7/19.
//  Copyright © 2019 ThangTM-PC. All rights reserved.
//

import Foundation

struct CombineResponseErrorAndData: Error {
    var dataError: Data?
    var responseError: HttpResponseError?
}
