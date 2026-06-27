const mongoose = require("mongoose");

const shopSchema = new mongoose.Schema(
  {
    ownerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    shopName: {
      type: String,
      required: true,
    },

    category: {
      type: String,
      required: true,
    },

    phone: String,

    address: String,

    city: String,

    state: String,

    pincode: String,

    description: String,

    experience: Number,

    openingTime: String,

    closingTime: String,

    shopLogo: {
      type: String,
      default: "",
    },

    shopImage: {
      type: String,
      default: "",
    },

    rating: {
      type: Number,
      default: 0,
    },

    totalOrders: {
      type: Number,
      default: 0,
    },

    isVerified: {
      type: Boolean,
      default: false,
    },

    latitude: Number,

    longitude: Number,
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Shop", shopSchema);