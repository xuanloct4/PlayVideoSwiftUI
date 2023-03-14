//
//  PlaylistsView.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 20/12/2022.
//

import SwiftUI
let jsonString = """
    [
        {
            "course":"course1",
            "teacher":"teacherName1"
        },
        {
            "course":"course1",
            "teacher":"teacherName2"
        },
        {
            "course":"course1",
            "teacher":"teacherName3"
        },
        {
            "course":"course1",
            "teacher":"teacherName4"
        },
        {
            "course":"course1",
            "teacher":"teacherName5"
        },
        {
            "course":"course1",
            "teacher":"teacherName6"
        },
        {
            "course":"course1",
            "teacher":"teacherName7"
        },
        {
            "course":"course1",
            "teacher":"teacherName8"
        },
        {
            "course":"course1",
            "teacher":"teacherName9"
        },
        {
            "course":"course1",
            "teacher":"teacherName10"
        },
        {
            "course":"course1",
            "teacher":"teacherName11"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName12"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName13"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName14"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName15"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName16"
        },
        {
            "course":"course1",
            "teacher":"teacherName17"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName18"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName19"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName20"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName21"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName22"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName23"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName24"
        }
        ,
        {
            "course":"course1",
            "teacher":"teacherName25"
        }

    ]
"""

let data = jsonString.data(using: .utf8) ?? Data()


struct Course: Codable, Identifiable {

    var id = UUID()
    let course: String
    let teacher: String
}

struct PlaylistsView: View {
    let courses: [Course] = (try? JSONDecoder().decode([Course].self, from: data)) ?? []
    
    var body: some View {
        List(courses) { course in
            HStack {
                Text(course.course)
                Spacer()
                Text(course.teacher)
            }
        }
    }
}

struct PlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistsView()
    }
}
