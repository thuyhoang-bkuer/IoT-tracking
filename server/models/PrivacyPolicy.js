const { Schema, model } = require("mongoose");

const privacyPolicySchema = new Schema({
    deviceId: {
        type: String,
        required: true,
    },

    timeStart: {
        type: Number,
    },

    timeEnd: {
        type: Number,
    },

    user: {
        type: Schema.Types.ObjectId,
        ref: "User",
    },
    place: {
        type: Schema.Types.ObjectId,
        ref: "Place",
    }
});

const PrivacyPolicy = model("PrivacyPolicy", privacyPolicySchema);

module.exports = PrivacyPolicy;
