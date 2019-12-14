var http = require('http');
var url = require('url');

// not fully rfc compliant but ok for testing
function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

var accessToken = uuidv4();

var users = [
    {
        "name": "Viki Dobreva",
        "id": 1,
        "events" : [1, 3],
        "profile-pic": "https://media.istockphoto.com/photos/portrait-of-a-cheerful-young-man-picture-id640021202?k=6&m=640021202&s=612x612&w=0&h=M7WeXoVNTMI6bT404CHStTAWy_2Z_3rPtAghUXwn2rE="
    },
    {
        "name": "Petar",
        "id": 2,
        "events" : [2],
        "profile-pic": "https://media.istockphoto.com/photos/portrait-of-a-cheerful-young-man-picture-id640021202?k=6&m=640021202&s=612x612&w=0&h=M7WeXoVNTMI6bT404CHStTAWy_2Z_3rPtAghUXwn2rE="
    },
    {
        "name": "Kalin",
        "id": 3,
        "events" : [3],
        "profile-pic": "https://media.istockphoto.com/photos/portrait-of-a-cheerful-young-man-picture-id640021202?k=6&m=640021202&s=612x612&w=0&h=M7WeXoVNTMI6bT404CHStTAWy_2Z_3rPtAghUXwn2rE="
    },
    {
        "name": "Asen",
        "id": 4,
        "events" : [3],
        "profile-pic": "https://media.istockphoto.com/photos/portrait-of-a-cheerful-young-man-picture-id640021202?k=6&m=640021202&s=612x612&w=0&h=M7WeXoVNTMI6bT404CHStTAWy_2Z_3rPtAghUXwn2rE="
    }
]

var goals = [
    {
        "name": "New car",
        "id": 1,
        "progress" : 18,
        "created-by" : 1,
        "image": [
                  "http://images.mentalfloss.com/sites/default/files/styles/mf_image_3x2/public/beerfest.png?itok=y9cLMuKD&resize=1100x740"
        ]
    },
    {
        "name": "Trip to London",
        "id": 2,
        "progress" : 76,
        "created-by" : 1,
        "image": [
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjIULiQ5LSnq_hzWnovENr2PnCaRzVpZYVTc4hW08m0UwucIOkMw"
        ]
    },
    {
        "name": "New phone",
        "id": 3,
        "progress" : 65,
        "created-by" : 1,
        "image": [
            "http://i.telegraph.co.uk/multimedia/archive/02657/SkicrossBODY2_2657502a.jpg"
        ]
    }
]

console.log("Generated access token: " + accessToken)

commonHeaders = {
    "Content-type": "application/json"
};

function setResponse(res, code, headers, data) {
    res.statusCode = code;
    for (var k in headers) {
        res.setHeader(k, headers[k])
    }
    if (! (data instanceof String)) {
        data = JSON.stringify(data)
    }
    data += '\r\n'
    res.setHeader("Content-Length", Buffer.byteLength(data))
    res.end(data)
}

function onLogin(req, res) {
    var query = url.parse(req.url, true).query;

    if(query.user == "admin" && query.pass == "pass") {
        setResponse(res, 200, commonHeaders, {"access-token" : accessToken})
    } else {
        setResponse(res, 403, {}, "Error in authrorization")
    }
}

function onUser(req, res) {
    if(req.headers["access-token"] == accessToken) {
        setResponse(res, 200, commonHeaders, users[0])
    } else {
        setResponse(res, 403, {}, "Error")
    }
}

function onOtherUser(req, res) {
    if(req.headers["access-token"] == accessToken) {
        var query = url.parse(req.url, true).query;
        if (query.userid <= users.length) {
            setResponse(res, 200, commonHeaders, users[query.userid - 1])
        } else {
            setResponse(res, 400, {}, "No such user")
        }
    } else {
        setResponse(res, 403, {}, "Error")
    }
}

function onGoals(req, res) {
    if(req.headers["access-token"] == accessToken) {
        setResponse(res, 200, commonHeaders, {"ids": [1, 2, 3]})
    } else {
        setResponse(res, 403, {}, "Error")
    }
}

function onGoal(req, res) {
    if(req.headers["access-token"] == accessToken) {
        var query = url.parse(req.url, true).query;

        if (query.goalid <= goals.length) {
            setResponse(res, 200, commonHeaders, goals[query.goalid - 1])
        } else {
            setResponse(res, 400, {}, "No such event")
        }
    } else {
        setResponse(res, 403, {}, "Error")
    }
}

function onAddGoal(req, res) {
    if(req.headers["access-token"] == accessToken) {
        var query = url.parse(req.url, true).query;

        var event = {}
        event.id = events.length
        event.name = query.name
        event.progress = query.progress
        event['created-by'] = 1

        events.push(event)
        setResponse(res, 200, commonHeaders, {"id": event.id + 1})

        users[0].events.push(event.id + 1)

    } else {
        setResponse(res, 403, {}, "Access denied")
    }
}

http.createServer(function (req, res) {
    var request = url.parse(req.url, true);

    var path = request.pathname;

    if(req.method == "GET") {
        switch(path) {
            // login
            case "/login":
                onLogin(req, res)
                break;

            case "/userinfo":
                onUser(req, res)
                break;

            case "/user":
                onOtherUser(req, res)
                break;

            case "/goals":
                onGoals(req, res)
                break;

            case "/goal":
                onGoal(req, res)
                break;

            // used to test sent data return the sent data
            case "/test":
                setResponse(res, 200, {}, request)

            // no such option
            default:
                setResponse(res, 404, {}, "API not available")
        }
    }

    if(req.method == "POST") {
        switch(path) {

            case "/addevent":
                onAddEvent(req, res)
                break;

            // no such option
            default:
                setResponse(res, 404, {}, "API not available")
        }
    }

    console.log(req.method + " " + path + " " + res.statusCode + " " + res.statusMessage)

}).listen(8080);
