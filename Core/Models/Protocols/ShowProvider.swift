//
//  ShowProvider.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import PromiseKit

public protocol ShowProvider {
    func retrieveShows(page: Int) -> Promise<[Show]>
    func retrieveShows(searchTerm: String) -> Promise<[Show]>
    func retrieveShow(id: Int) -> Promise<Show>
    func retrieveEpisodes(show: Show) -> Promise<Show>
}
