const express = require("express");

const {
  createOrder,
  getOrders,
} = require("../controllers/orderController");

const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

// Create Order
router.post(
  "/",
  authMiddleware,
  createOrder,
);

// Get Logged-in User Orders
router.get(
  "/",
  authMiddleware,
  getOrders,
);
module.exports = router;