//
//  ecommerceTests.swift
//  ecommerceTests
//
//  Created by Guy Daher on 02/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Quick
import Nimble
@testable import ecommerce
import InstantSearchCore
import AlgoliaSearch

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("InstantSearch") {
            it("has everything you need to get started") {
                let x = 5
                let client = Client(appID: "aa", apiKey: "bb")
                let index = client.index(withName: "cc")
                let instantSearch = InstantSearch(searcher: Searcher(index: index))
                expect(instantSearch).toNot(beNil())
                expect(x).to(equal(5))
            }
            
//            context("if it doesn't have what you're looking for") {
//                it("needs to be updated") {
//                    let you = You(awesome: true)
//                    expect{you.submittedAnIssue}.toEventually(beTruthy())
//                }
//            }
        }
    }
}
