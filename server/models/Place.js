const { Schema, model } = require("mongoose");

const placeSchema = new Schema({
    name: {
        type: String,
        require: true,
    },
    listPoints: {
        type: [[Number]],
    }
});

const Place = model("Place",placeSchema);
    
module.exports = Place;