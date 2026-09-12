const mongoose = require("mongoose");

const orderSchema = new mongoose.Schema(
  {
    // Customer
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    customerName: {
      type: String,
      required: true,
    },

    customerEmail: {
      type: String,
      required: true,
    },

    customerPhone: {
      type: String,
      default: "",
    },

    // Shop
    shopId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Shop",
      required: true,
    },

    shopName: {
      type: String,
      required: true,
    },

    // Provider
    providerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    // Service
    serviceName: {
      type: String,
      required: true,
    },

    address: {
      type: String,
      required: true,
    },

    quantity: {
      type: Number,
      required: true,
    },

    amount: {
      type: Number,
      required: true,
    },

    paymentStatus: {
      type: String,
      enum: ["Pending", "Paid"],
      default: "Pending",
    },

    orderStatus: {
      type: String,
      enum: [
        "Pending",
        "Accepted",
        "On The Way",
        "Completed",
        "Cancelled",
      ],
      default: "Pending",
    },

    workerName: {
      type: String,
      default: "",
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Order", orderSchema);