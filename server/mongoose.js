const mongoose = require("mongoose");
const User = require("./components/user/userDAL");

const username = encodeURI("root");
const password = encodeURI("root");
const address = "localhost:27017";
const dbName = encodeURI("tracking-lover");
const authSource = "admin";

const connectionURL = `mongodb://${username}:${password}@${address}/${dbName}?authSource=${authSource}`;

mongoose.connect(connectionURL, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useCreateIndex: true,
});
