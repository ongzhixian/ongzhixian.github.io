# Reference MongoDB DLLs
Add-Type -Path 'C:\src\github.io\lib\MongoDB\MongoDB.Driver.dll'
Add-Type -Path 'C:\src\github.io\lib\MongoDB\MongoDB.Bson.dll'
Add-Type -Path 'C:\src\github.io\lib\MongoDB\MongoDB.Libmongocrypt.dll'

Add-Type -Path '/Users/zhixian/src/github.com/ongzhixian/github.io/lib/MongoDB/MongoDB.Driver.dll'
Add-Type -Path '/Users/zhixian/src/github.com/ongzhixian/github.io/lib/MongoDB/MongoDB.Bson.dll'
Add-Type -Path '/Users/zhixian/src/github.com/ongzhixian/github.io/lib/MongoDB/MongoDB.Libmongocrypt.dll'

# MongoDB.Driver.MongoClient client = new MongoDB.Driver.MongoClient();

[MongoDB.Driver.MongoClient] $client = [MongoDB.Driver.MongoClient]::new("mongodb://developer:Password1234@ds245548.mlab.com:45548/kbnet?retryWrites=false")
[MongoDB.Driver.IMongoDatabase] $db = $client.GetDatabase("kbnet");

$db = $client.GetDatabase("kbnet")

$method = [MongoDB.Driver.IMongoDatabase].GetMethod("GetCollection")
$gMethod = $method.MakeGenericMethod([MongoDB.Bson.BsonDocument])
$a = $gMethod.Invoke($db, @("Books", $null))

[MongoDB.Driver.IMongoCollection[MongoDB.Bson.BsonDocument]]$b = $gMethod.Invoke($db, @("Books", $null))

$a.Count("{}", $null, [System.Threading.CancellationToken]::None)

void InsertOne(MongoDB.Bson.BsonDocument document, MongoDB.Driver.InsertOneOptions options, System.Threading.CancellationToken cancellationToken)

[MongoDB.Bson.BsonDocument] $doc = @{
    "_id"= [MongoDB.Bson.ObjectId]::GenerateNewId();
    "FirstName"= "Yves";
    "LastName"= "Germain";
    "PhoneNumbers"= [MongoDB.Bson.BsonDocument] @{
        'Home'= '555-555-1212';
        'Mobile'= '555-555-1212';
    };
};



$a.InsertOne($doc, $null, [System.Threading.CancellationToken]::None)


# System.Reflection.MethodInfo MakeGenericMethod(Params type[] methodInstantiation)
# [MongoDB.Driver.IMongoDatabase].GetMethod("GetCollection").MakeGenericMethod([MongoDB.Bson.BsonDocument])


# Example of complex generic type
# [System.Collections.Generic.Dictionary[int,string[]]]


$db.CreateCollection("Items", $null, [System.Threading.CancellationToken]::None)





#####################

# Not working


$t = [System.Collections.Generic.Dictionary`2].MakeGenericType([string], [object]) 
$o = [Activator]::CreateInstance($t)
$o.Add("author", "zhixian")
$d = [MongoDB.Bson.BsonDocument]::new($o)



$q = [System.Collections.Generic.Dictionary[string,object]]::new()
$q.Add("", "a")
$d = [MongoDB.Bson.BsonDocument]::new($q)


# MongoDB.Driver.IMongoCollection<MongoDB.Bson.BsonDocument> a;

[MongoDB.Driver.IMongoCollection[MongoDB.Bson.BsonDocument]]$a = $gMethod.Invoke($db, @("Books", $null))


[MongoDB.Driver.FilterDefinition[MongoDB.Bson.BsonDocument]]::new

$db.CreateCollection("Items")

#$db.GetCollection[MongoDB.Bson.BsonDocument]("Books")

void IMongoDatabase.CreateCollection(string name, MongoDB.Driver.CreateCollectionOptions options,
System.Threading.CancellationToken cancellationToken)

$db.CreateCollection("SomeNewCol", [MongoDB.Driver.CreateCollectionOptions]$null, [System.Threading.CancellationToken]::None)


# MongoDB.Bson.BsonDocument doc;

# $db = [MongoDB.Driver.MongoDatabase]::Create('mongodb://localhost/profiles');
# $coll = $db['example1'];




#$col = $db.GetCollection<Book>("Books");


# booksCollection.InsertOne(new Book
# {
#     Title = "Gur",
#     Author = "Eddings"

# });
