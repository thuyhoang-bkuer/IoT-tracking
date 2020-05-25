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
});

const PrivacyPolicy = model("PrivacyPolicy", privacyPolicySchema);

module.exports = PrivacyPolicy;
