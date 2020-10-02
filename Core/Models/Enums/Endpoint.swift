//
//  Endpoint.swift
//  TvMaze
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import Foundation

public enum Endpoint: String {
    case retrieveShows = "RetrieveShows"
    case retrieveShow = "RetrieveShow"
    case retrieveShowsFromSearch = "RetrieveShowsFromSearch"
    case retrieveEpisodes = "RetrieveEpisodes"
    case retrievePeople = "RetrievePeople"
    case retrieveShowsFromPerson = "RetrieveShowsFromPerson"
}