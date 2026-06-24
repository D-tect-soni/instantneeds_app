const mongoose = require("mongoose");

const orderSchema = new mongoose.Schema(
  {
    userId: String,

    serviceName: String,

    address: String,

    quantity: Number,

    amount: Number,

    paymentStatus: {
      type: String,
      default: "Pending",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Order", orderSchema);