//
//  CacheManager.swift
//  SpacePro
//
//  Created by XiaorAx on 2021/10/10.
//

import Foundation
import UIKit


class CacheManager {
    static let shared = CacheManager()
    
    func getAlbums(type: MenuType) -> [Album] {
        if let json = UserDefaults.standard.data(forKey: type.rawValue) {
            let decoder = JSONDecoder()
            if let models = try? decoder.decode(Array<Album>.self, from: json) {
                return models
            }
        }
        return []
    }
    
    func addAlbum(_ album:Album, type: MenuType) {
        var albums = getAlbums(type: type)
        
        albums.append(album)
        
        if let model = try? JSONEncoder().encode(albums) {
            UserDefaults.standard.set(model, forKey: type.rawValue)
        }
    }
    
    func addMedia(_ image:Media, _ album: Album) {
        var images = getMedias(in: album)
        images.append(image)
        
        if let model = try? JSONEncoder().encode(images) {
            UserDefaults.standard.set(model, forKey: "album_\(album.id)")
        }
    }
    
    func getMedias(in album:Album) -> [Media]{
        if let json = UserDefaults.standard.data(forKey: "album_\(album.id)") {
            let decoder = JSONDecoder()
            if let models = try? decoder.decode(Array<Media>.self, from: json) {
                return models
            }
        }
        return []
    }
    
    func deleteMedia(in album:Album, index:Int){
        var images = getMedias(in: album)
        
        images.remove(at: index)
        
        if let model = try? JSONEncoder().encode(images) {
            UserDefaults.standard.set(model, forKey: "album_\(album.id)")
        }
    }
    
    func addnote(_ note:Note) {
        var notes = getNotes()
        notes.append(note)
        
        if let model = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(model, forKey: "notes")
        }
    }
    
    func addNumber(_ number:Number) {
        var numbers = getNumbers()
        numbers.append(number)
        
        if let model = try? JSONEncoder().encode(numbers) {
            UserDefaults.standard.set(model, forKey: "numbers")
        }
    }
    
    func getNumbers() -> [Number]{
        if let json = UserDefaults.standard.data(forKey: "numbers") {
            let decoder = JSONDecoder()
            if let models = try? decoder.decode(Array<Number>.self, from: json) {
                return models
            }
        }
        return []
    }
    
    func modifyNumber(_ number:Number) {
        let numbers = getNumbers()
        
        var arr:[Number] = []
        for n in numbers {
            if (number.id == n.id) {
                arr.append(number)
            } else {
                arr.append(n)
            }
        }
        if let model = try? JSONEncoder().encode(arr) {
            UserDefaults.standard.set(model, forKey: "numbers")
        }
    }
    
    func deleteNote(_ note:Note) {
        var notes = getNotes()
        notes.removeAll { n in
            return n.id == note.id
        }
        
        if let model = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(model, forKey: "notes")
        }
    }
    
    func deleteNumber(_ number:Number) {
        var numbers = getNumbers()
        numbers.removeAll { n in
            return n.id == number.id
        }
        
        if let model = try? JSONEncoder().encode(numbers) {
            UserDefaults.standard.set(model, forKey: "numbers")
        }
    }
    
    func getNotes() -> [Note]{
        if let json = UserDefaults.standard.data(forKey: "notes") {
            let decoder = JSONDecoder()
            if let models = try? decoder.decode(Array<Note>.self, from: json) {
                return models
            }
        }
        return []
    }
    
    func modifyNote(_ note:Note) {
        let notes = getNotes()
        
        var arr:[Note] = []
        for n in notes {
            if (note.id == n.id) {
                arr.append(note)
            } else {
                arr.append(n)
            }
        }
        if let model = try? JSONEncoder().encode(arr) {
            UserDefaults.standard.set(model, forKey: "notes")
        }
    }
}
