// mongodb+srv://tuan:<password>@cluster0-pqxpc.mongodb.net/test?retryWrites=true&w=majority
require('dotenv').config();
const express = require('express');
const app = express();
const mongoose = require('mongoose');
const bodyParser = require('body-parser');

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const coordinatesRoute = require('./routes/coordinate');
app.use('/coordinate', coordinatesRoute);

const locationRoute = require('./routes/location');
app.use('/location', locationRoute);

const ppcoordinateRoute = require('./routes/ppcoordinate');
app.use('/ppcoordinate', ppcoordinateRoute);

const privatepolicyRoute = require('./routes/privacypolicy');
app.use('/privatepolicy', privatepolicyRoute);

const userRoute = require('./routes/user');
app.use('/user', userRoute);

const placeRoute = require('./routes/place');
app.use('/placement', placeRoute);



app.get('/', (req, res) => {
    res.send('We are on home');
});


mongoose.connect(process.env.DB_CONNECTION, {useUnifiedTopology: true, useNewUrlParser: true, useCreateIndex: true });
mongoose.connection.once("open", () => console.log("Connected")).on("error", error => {
    console.log("Ur error ", error)
});

app.listen(3000, () => console.log(`Listening on port 3000`));
