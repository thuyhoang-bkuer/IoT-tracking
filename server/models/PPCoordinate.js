const { Schema, model } = require("mongoose");

const PPCoordinateSchema = new Schema({
    ppid: {
        type: Schema.Types.ObjectId,
        ref: "PrivacyPolicy",
    },

    coordinate: {
        type: Schema.Types.ObjectId,
        ref: "Coordinate",
    },
    place: {
        type: String,
        required: true,
    }
});

const PPCoordinate = model("PPCoordinate", PPCoordinateSchema);
module.exports = PPCoordinate;

