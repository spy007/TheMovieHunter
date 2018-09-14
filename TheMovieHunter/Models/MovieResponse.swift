/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

public class MovieResponse : Decodable {
    var vote_count : Int?
    var id : Int?
    var video : Bool?
    var vote_average : Double?
    var title : String?
    var popularity : Double?
    var poster_path : String?
    var original_language : String?
    var original_title : String?
    var genre_ids : Array<Int>?
    var backdrop_path : String?
    var adult : Bool?
    var overview : String?
    var release_date : String?

//    override public class func primaryKey() -> String? {
//        return "id"
//    }
    
//    public func getId() -> Int! {
//        return id
//    }
//
//    public func setId (id: Int!) {
//        self.id = id
//    }
}
