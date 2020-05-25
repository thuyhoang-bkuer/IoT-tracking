const { Schema, model } = require("mongoose");

const coordinateSchema = new Schema({
    longitude: {
        type: Number,
        required: true,
    },

    latitude: {
        type: Number,
        required: true,
    },
});

const Coordinate = model("Coordinate", coordinateSchema);

module.exports = Coordinate;
