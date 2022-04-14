//
//  SearchParts.swift
//  CustomPC
//
//  Created by Kai on 2022/04/10.
//

import Foundation

import Alamofire
import Kanna

class SearchParts {
    static func getPartsTitleFirst(parts: PcParts,completionHandler: @escaping (Array<String>) -> Void) {
        // alamofile encodingの引数にshiftJisを指定して文字化け回避
        AF.request(parts.startPageUrl()).responseString (encoding: String.Encoding.shiftJIS){ response in
            if let html = response.value {
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                    var titles = [String]()
                    var category = [String]()
                    // ページのパーツ数取得
                    let elements: Int = doc.xpath("//*[@id=\"default\"]/div[2]/div[2]/div/div[4]/div/div").count
                    // パーツの名前取得
                    for i in 1 ... (elements) {
                        let title = "//*[@id=\"default\"]/div[2]/div[2]/div/div[4]/div/div[\(i)]/div/div[1]/div[1]/div/p[2]"
                        for link in doc.xpath(title) {
                            titles.append(link.text ?? "")
                        }
                    }
                    
                    for i in 1 ... (elements) {
                        let title = "//*[@id=\"default\"]/div[2]/div[2]/div/div[4]/div/div[\(i)]/div/div[1]/div[1]/div/div[1]/p[1]"
                        for link in doc.xpath(title) {
                            category.append(link.text ?? "")
                        }
                    }
                    print(titles)
                    print(category)
                    completionHandler(titles)
                }else {
                    print("doc was null")
                }
            }else {
                print("html was null")
            }
        }
    }
}
