var http = require('http');
var url = require('url');
var mysql = require('mysql');

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "ISpanski97"
});

function createDB() {
    con.connect(function(err) {
      if (err) throw err;
      console.log("Connected!");
      con.query("CREATE DATABASE IF NOT EXISTS TransactionsDB", function (err, result) {
        if (err) throw err;
      });
    });

    con = mysql.createConnection({
      host: "localhost",
      user: "root",
      password: "ISpanski97",
      database: "TransactionsDB"
    });

    var sql = "CREATE TABLE IF NOT EXISTS Transactions (name VARCHAR(255), id MEDIUMINT NOT NULL AUTO_INCREMENT, date VARCHAR(256), sum DOUBLE, card VARCHAR(256), location VARCHAR(256), PRIMARY KEY (id))";
      
    con.query(sql, function (err, result) {
        if (err) throw err;
    });
    
    var sql = "INSERT INTO Transactions (name, date, sum, card, location) VALUES ('BGR SOFIA SHELL PODUENE', '2019-12-13 13:14:07', '81.84', 'Visa *0367', '42.696381 23.355913'),('BGR SOFIYA FANTASTIKO 28', '2019-12-12 10:47:13', '2.29', 'Visa *0367', '42.679714 23.367812'),('BGR SOFIA HAPPY BAR GRILL', '2019-12-11 21:34:15', '38.65', 'Visa *0367', '42.648145 23.379201');";
    
    con.query(sql, function (err, result) {
        if (err) throw err;
    });

}

function selectAllTransactionsFromDB(callback) {
    con.query("SELECT * FROM Transactions", function (err, result, fields) {
        if (err) throw err;
        callback(result);
    });
}

function selectAllIDsFromDB(callback) {
    con.query("SELECT id FROM Transactions", function (err, result, fields) {
        if (err) throw err;
        callback(result);
    });
}

function selectByIDFromDB(id, callback) {
    con.query("SELECT * FROM Transactions WHERE id = " + mysql.escape(id), function (err, result, fields) {
        if (err) throw err;
        callback(result);
    });
}

createDB();

function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

var accessToken = uuidv4();

var goals = [
    {
        "name": "New car",
        "id": 1,
        "goalSum" : 12500,
        "currentSum" : 1300,
        "created-by" : 1,
        "image": [
                  "https://cdn.motor1.com/images/mgl/Je7nQ/s1/2020-alfa-romeo-stelvio.jpg"
        ]
    },
    {
        "name": "Trip to London",
        "id": 2,
        "goalSum" : 1100,
        "currentSum" : 434,
        "created-by" : 1,
        "image": [
            "https://cdn.londonandpartners.com/assets/73295-640x360-london-skyline-ns.jpg"
        ]
    },
    {
        "name": "New phone",
        "id": 3,
        "goalSum" : 830,
        "currentSum" : 779,
        "created-by" : 1,
        "image": [
            "https://gloimg.gbtcdn.com/soa/gb/pdm-product-pic/Electronic/2019/11/08/goods_img_big-v23/20191108175625_65552.jpg"
        ]
    }
]

var goalIDs = [];
for (i = 0; i < goals.length; i++) {
  goalIDs.push(i+1);
}

var user =
    {
        "name": "Ivan Ganchev",
        "id": 1,
        "frequency": 1,
        "roundingUp": 2,
        "savedTotal": 0,
        "numberOfTransactions": 0,
        "profile-pic": "https://media.istockphoto.com/photos/portrait-of-a-cheerful-young-man-picture-id640021202?k=6&m=640021202&s=612x612&w=0&h=M7WeXoVNTMI6bT404CHStTAWy_2Z_3rPtAghUXwn2rE="
    }


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
        setResponse(res, 200, commonHeaders, user)
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
            setResponse(res, 400, {}, "No such goal")
        }
    } else {
        setResponse(res, 403, {}, "Error")
    }
}

function onTransactions(req, res) {
    if(req.headers["access-token"] == accessToken) {
        selectAllIDsFromDB( function(result) {
            var results = [];
            for (resu of result) {
             results.push(resu.id);
            }
            setResponse(res, 200, commonHeaders, {"ids": results})
        });
    } else {
        setResponse(res, 403, {}, "Error")
    }
}

function onTransaction(req, res) {
    if(req.headers["access-token"] == accessToken) {
        var query = url.parse(req.url, true).query;
        selectByIDFromDB(query.transactionid, function (result) {
            setResponse(res, 200, commonHeaders, result)
        });
    } else {
        setResponse(res, 403, {}, "Error")
    }
}

function onAddSaved(req, res) {
    if(req.headers["access-token"] == accessToken) {
        var query = url.parse(req.url, true).query;
        
        user.savedTotal += query.saved - 0
        
        setResponse(res, 200, commonHeaders)
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

            case "/goals":
                onGoals(req, res)
                break;

            case "/goal":
                onGoal(req, res)
                break;
                  
            case "/transactions":
                onTransactions(req, res)
                break;
            
            case "/transaction":
                onTransaction(req, res)
                break;
                  
            case "/addsaved":
                onAddSaved(req, res)
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

            case "/addsaved":
                onAddSaved(req, res)
                break;

            // no such option
            default:
                setResponse(res, 404, {}, "API not available")
        }
    }

    console.log(req.method + " " + path + " " + res.statusCode + " " + res.statusMessage)

}).listen(8080);
