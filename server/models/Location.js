const { Schema, model } = require("mongoose");

const locationSchema = new Schema({
    deviceId: {
        type: String,
        required: true,
    },

    timestamp: {
        type: Number,
        required: true,
        default: new Date().getTime(),
    },

    coordinate: {
        type: Schema.Types.ObjectId,
        ref: "coordinate",
    },

    user: {
        type: Schema.Types.ObjectId,
        ref: "User",
    },
});

const Location = model("Location", locationSchema);

module.exports = Location;
