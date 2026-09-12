const express = require("express");

const {
  createOrder,
  getOrders,
  getProviderDashboard,
  acceptOrder,
  rejectOrder,
  completeOrder,
  getProviderEarnings,
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

// Provider Dashboard
router.get(
  "/provider/dashboard",
  authMiddleware,
  getProviderDashboard,
);
router.get(
  "/provider/earnings",
  authMiddleware,
  getProviderEarnings,
);

// Accept Order
router.patch(
  "/:id/accept",
  authMiddleware,
  acceptOrder,
);

// Reject Order
router.patch(
  "/:id/reject",
  authMiddleware,
  rejectOrder,
);

// Complete Order
router.patch(
  "/:id/complete",
  authMiddleware,
  completeOrder,
);
module.exports = router;