const { Schema, model } = require("mongoose");
const validator = require("validator");

const userSchema = new Schema({
    email: {
        type: String,
        required: true,
        validate: (value) => validator.isEmail(value),
    },

    password: {
        type: String,
        required: true,
        validate: (value) => {
            if (value.trim().length < 8) {
                throw new Error("Password's length must be greater than 8");
            }

            return true;
        },
    },

    admin: {
        type: Schema.Types.ObjectId,
        ref: "User",
    },
});

const User = model("User", userSchema);

module.exports = User;
