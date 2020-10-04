//
//  Endpoint.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Foundation

// The MazeTV endpoints we use
public enum Endpoint: String {
    case retrieveShows = "RetrieveShows"
    case retrieveShow = "RetrieveShow"
    case retrieveShowsFromSearch = "RetrieveShowsFromSearch"
    case retrieveEpisodes = "RetrieveEpisodes"
    case retrievePeople = "RetrievePeople"
    case retrieveShowsFromPerson = "RetrieveShowsFromPerson"
}
