const Order = require("../models/Order");
const User = require("../models/User");
const Shop = require("../models/Shop");

// ======================
// Create Order
// ======================
const createOrder = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({
        message: "User not found",
      });
    }

    const {
      shopId,
      serviceName,
      address,
      quantity,
      amount,
    } = req.body;

    // Find Shop
    const shop = await Shop.findById(shopId);

    if (!shop) {
      return res.status(404).json({
        message: "Shop not found",
      });
    }

    const order = await Order.create({
      // Customer
      userId: user._id,
      customerName: user.name,
      customerEmail: user.email,
      customerPhone: user.phone,

      // Shop
      shopId: shop._id,
      shopName: shop.shopName,

      // Provider
      providerId: shop.ownerId,

      // Service
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

// ======================
// Get Customer Orders
// ======================
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

// ======================
// Provider Dashboard
// ======================
const getProviderDashboard = async (req, res) => {
  try {
    const orders = await Order.find({
      providerId: req.user.id,
    }).sort({
      createdAt: -1,
    });

    const totalOrders = orders.length;

    const pendingOrders = orders.filter(
      (o) => o.orderStatus === "Pending"
    ).length;

    const acceptedOrders = orders.filter(
      (o) => o.orderStatus === "Accepted"
    ).length;

    const completedOrders = orders.filter(
      (o) => o.orderStatus === "Completed"
    ).length;

    res.json({
      totalOrders,
      pendingOrders,
      acceptedOrders,
      completedOrders,
      orders,
    });

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};
// Accept Order
const acceptOrder = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({
        message: "Order not found",
      });
    }

    order.orderStatus = "Accepted";
    await order.save();

    res.json({
      message: "Order Accepted Successfully",
      order,
    });

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

// Reject Order
const rejectOrder = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({
        message: "Order not found",
      });
    }

    order.orderStatus = "Cancelled";
    await order.save();

    res.json({
      message: "Order Cancelled Successfully",
      order,
    });

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

// Complete Order
const completeOrder = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({
        message: "Order not found",
      });
    }

    order.orderStatus = "Completed";
    await order.save();

    res.json({
      message: "Order Completed Successfully",
      order,
    });

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};
// ======================
// Provider Earnings
// ======================
const getProviderEarnings = async (req, res) => {
  try {
    const orders = await Order.find({
      providerId: req.user.id,
      orderStatus: "Completed",
    });

    const now = new Date();

    let today = 0;
    let week = 0;
    let month = 0;
    let total = 0;

    orders.forEach((order) => {
      total += order.amount;

      const created = new Date(order.createdAt);

      // Today
      if (
        created.toDateString() === now.toDateString()
      ) {
        today += order.amount;
      }

      // Last 7 Days
      const diff =
        (now - created) / (1000 * 60 * 60 * 24);

      if (diff <= 7) {
        week += order.amount;
      }

      // Current Month
      if (
        created.getMonth() === now.getMonth() &&
        created.getFullYear() === now.getFullYear()
      ) {
        month += order.amount;
      }
    });

    res.json({
      today,
      week,
      month,
      total,
    });

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

// ======================
// Exports
// ======================
module.exports = {
  createOrder,
  getOrders,
  getProviderDashboard,
  acceptOrder,
  rejectOrder,
  completeOrder,
  getProviderEarnings,
};