const Order = require("../models/Order");
const User = require("../models/User");

// Create Order
const createOrder = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({
        message: "User not found",
      });
    }

    const {
      serviceName,
      address,
      quantity,
      amount,
    } = req.body;

    const order = await Order.create({
      userId: user._id,

      customerName: user.name,

      customerEmail: user.email,

      customerPhone: user.phone,

      serviceName,

      address,

      quantity,

      amount,

      paymentStatus: "Pending",

      orderStatus: "Pending",
    });

    res.status(201).json({
      message: "Order Placed Successfully",
      order,
    });

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

// Get Orders of Logged-in User
const getOrders = async (req, res) => {
  try {

    const orders = await Order.find({
      userId: req.user.id,
    }).sort({
      createdAt: -1,
    });

    res.json(orders);

  } catch (error) {

    res.status(500).json({
      message: error.message,
    });

  }
};

module.exports = {
  createOrder,
  getOrders,
};