//
//  Parser.swift
//  RSS Feeds
//
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import Foundation
class Parser: NSObject{
    // Element tags From XML Response
    enum xmlTags: String {
        case item = "item"
        case title = "title"
        case link = "link"
        case pubDate = "pubDate"
    }
    private var feedItems: [FeedModel] = []
    private var currentElement = ""
    private var currentTitle: String = ""{
        didSet{
            currentTitle = currentTitle.spaceAndLineTrimmer()
        }
    }
    private var currentLink:String = ""{
        didSet{
            currentLink = currentLink.spaceAndLineTrimmer()
        }
    }
    private var currentPubDate:String = ""{
        didSet{
            currentPubDate = currentPubDate.spaceAndLineTrimmer()
        }
    }
    private var parserCompletionHandler: (([FeedModel],Error?) -> Void)?
    /**
     Method that make an api call and parse XML data.
     
     - Parameter url: -url of type string.
     - Parameter completionHandler: -completionHandler of type *parserCompletionHandler: (([FeedModel],Error?) -> Void)?*

     */
    func parseFeeds(_ url: String, completionHandler: (([FeedModel],Error?) -> Void)?){
        guard URL(string: url) != nil else {
            return
        }
        self.parserCompletionHandler = completionHandler
        let urlRequest  = URLRequest(url: URL(string: url)!)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else{
                print(error?.localizedDescription ?? "")
                return
            }
            guard let data = data else{ return }
            // Once get the Data start Parsing From Here control Goes to XMLParser Delegate Methods
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }.resume()
        
    }
}

//MARK: - XMLParserDelegate Methods here
extension Parser: XMLParserDelegate{
    //Method get called When Get New Tag or Element
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        guard currentElement == xmlTags.item.rawValue else {return}
        currentTitle = ""
        currentLink = ""
        currentPubDate = ""
    }
    //Method get called to read the data from element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case xmlTags.title.rawValue: currentTitle += string
        case xmlTags.link.rawValue: currentLink += string
        case xmlTags.pubDate.rawValue: currentPubDate += string
        default:
            break
        }
    }
    //Method get called when get End tag of Element
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard elementName == xmlTags.item.rawValue else {return}
        let feed = FeedModel(title: currentTitle, link: currentLink, pubDate: currentPubDate)
        feedItems.append(feed)
        
    }
    //Method get called when get End of the Document
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(feedItems,nil)
    }
    //Method get called when error occured
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        parserCompletionHandler?(feedItems,parseError)
    }
}
