/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import SQLite3
import PlaygroundSupport

destroyPart1Database()

/*:
 
 # Getting Started
 
 The first thing to do is set your playground to run manually rather than automatically. This will help ensure that your SQL commands run when you intend them to. At the bottom of the playground click and hold the Play button until the dropdown menu appears. Choose "Manually Run".
 
 You will also notice a `destroyPart1Database()` call at the top of this page. You can safely ignore this, the database file used is destroyed each time the playground is run to ensure all statements execute successfully as you iterate through the tutorial.
 
 Secondly, this Playground will need to write SQLite database files to your file system. Create the directory `~/Documents/Shared Playground Data/SQLiteTutorial` by running the following command in Terminal.
 
 `mkdir -p ~/Documents/Shared\ Playground\ Data/SQLiteTutorial`
 
 */

//: ## Open a Connection
func openDatabase() -> OpaquePointer? {
    var db: OpaquePointer? = nil
    if sqlite3_open(part1DbPath, &db) == SQLITE_OK {
        print("Successfully opened connection to database at \(part1DbPath)")
        return db
    }else{
        print("Unable to open database. Verify that you created the directory described " +
            "in the Getting Started section.")
        PlaygroundPage.current.finishExecution()
    }
}

let db = openDatabase()
//: ## Create a Table
let createTableString = """
CREATE TABLE Contact(
Id INT PRIMARY KEY NOT NULL,
Name CHAR(255));
"""

func createTable(){
    
    var createTableStatement: OpaquePointer? = nil
    
    if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
        
        if sqlite3_step(createTableStatement) == SQLITE_DONE {
            print("contact created")
        }else{
            print("unable create contact")
        }
    }else{
        print("Contact table statement cannot prepared")
    }
    
    sqlite3_finalize(createTableStatement)
}

createTable()
//: ## Insert a Contact
// Single Insert Data

let insertStatementString = "INSERT INTO Contact (Id, Name) VALUES (?, ?);"

func insert(){

    var insertStatement: OpaquePointer? = nil

    if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
        let id: Int32 = 1
        let name: NSString = "Boy"

        sqlite3_bind_int(insertStatement, 1, id)
        sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)

        if sqlite3_step(insertStatement) == SQLITE_DONE{
            print("insert success")
        }else{
            print("couldnot insert now")
        }
    }else{
        print("insert statement couldnot prepared")
    }

    sqlite3_finalize(insertStatement)

}

insert()

// Multiple Insert

//let insertStatementString = "INSERT INTO Contact (Id, Name) VALUES (?, ?);"
//
//func insert() {
//
//    var insertStatement: OpaquePointer? = nil
//
//    let names: [NSString] = ["Boy", "Taufik", "Mas Dodi", "Dimas"]
//
//    if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK{
//
//        for (index, name) in names.enumerated() {
//
//            let id = Int32(index + 1)
//            sqlite3_bind_int(insertStatement, 1, id)
//            sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
//
//            if sqlite3_step(insertStatement) == SQLITE_DONE {
//                print("inserted")
//            }else{
//                print("not inserted")
//            }
//
//            sqlite3_reset(insertStatement)
//
//        }
//
//        sqlite3_finalize(insertStatement)
//
//    } else {
//        print("INSERT not prepared")
//    }
//
//}
//
//insert()
//: ## Querying
// Show data table single

let queryStatementString = "SELECT * FROM Contact;"

func query() {
    var queryStatement: OpaquePointer? = nil

    if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {

        if sqlite3_step(queryStatement) == SQLITE_ROW {
             let id = sqlite3_column_int(queryStatement, 0)

            let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
            let name = String(cString: queryResultCol1!)


            print("Query Result:")
            print("\(id) | \(name)")

        } else {
            print("Query returned no results")
        }
    } else {
        print("SELECT statement could not be prepared")
    }

    sqlite3_finalize(queryStatement)
}

query()

//Show data table multiple

//let queryStatementString = "SELECT * FROM Contact;"
//
//func query(){
//    var queryStatement: OpaquePointer? = nil
//
//    if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//
//        while (sqlite3_step(queryStatement) == SQLITE_ROW) {
//
//            let id = sqlite3_column_int(queryStatement, 0)
//            let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
//            let name = String(cString: queryResultCol1!)
//
//            print("query result")
//            print("\(id) | \(name)")
//
//        }
//
//    } else {
//
//        print("SELECT NOT prepared")
//
//    }
//
//    sqlite3_finalize(queryStatement)
//
//}
//
//query()


// Update

let updateStatementString = "UPDATE Contact SET Name = 'Lorem' WHERE Id = 1;"

func update(){
    var updateStatement: OpaquePointer? = nil
    
    if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK{
        
        if sqlite3_step(updateStatement) == SQLITE_DONE{
            print("row update")
        }else{
            print("row didnt update")
        }
        
    }else{
        print("Update not prepared")
    }
    
    sqlite3_finalize(updateStatement)
}


update()
query()
//: ## Delete
let deleteStatmentString = "DELETE FROM Contact WHERE Id = 1"

func delete() {
    var deleteStatement: OpaquePointer? =  nil
    
    if sqlite3_prepare_v2(db, deleteStatmentString, -1, &deleteStatement, nil) == SQLITE_OK{
        
        if sqlite3_step(deleteStatement) == SQLITE_DONE{
            print("row deleted")
        }else{
            print("row not deleted")
        }
        
    }else{
        print("DELETE NOT prepare")
    }
    
    sqlite3_finalize(deleteStatement)
}

delete()
query()

//: ## Errors
let malformedQueryString = "SELECT stuff from Things WHERE Whatever;"

func prepareMalformedQuery() {
    var MalformedStatement: OpaquePointer? = nil
    
    if sqlite3_prepare_v2(db, malformedQueryString, -1, &MalformedStatement, nil) == SQLITE_OK{
        print("This Should not happened")
    }else{
        
        let errorMessage = String.init(cString: sqlite3_errmsg(db))
        print("Query not prepared \(errorMessage)")
    }
    
    sqlite3_finalize(MalformedStatement)
    
}

prepareMalformedQuery()
//: ## Close the database connection
sqlite3_close(db)
//: Continue to [Making It Swift](@next)

