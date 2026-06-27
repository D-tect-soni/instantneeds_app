const express = require("express");
const authMiddleware = require("../middleware/authMiddleware");

const {
  registerShop,
  getMyShop,
  updateShop,
  getVerifiedShops,
  getNearbyShops,
} = require("../controllers/shopController");

const router = express.Router();

// Register Shop
router.post(
  "/register",
  authMiddleware,
  registerShop
);

// Get My Shop
router.get(
  "/my-shop",
  authMiddleware,
  getMyShop
);

// Update Shop
router.put(
  "/update",
  authMiddleware,
  updateShop
);

// Get All Verified Shops
router.get(
  "/verified",
  getVerifiedShops
);

// Get Nearby Shops
router.get(
  "/nearby",
  getNearbyShops
);

module.exports = router;