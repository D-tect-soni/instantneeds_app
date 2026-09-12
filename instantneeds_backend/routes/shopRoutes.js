const express = require("express");
const authMiddleware = require("../middleware/authMiddleware");
const upload = require("../middleware/uploadMiddleware");
const {
  registerShop,
  getMyShop,
  updateShop,
  getVerifiedShops,
  getNearbyShops,
  getProviderStatus,
  uploadShopLogo,
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
// Provider Status
router.get(
  "/provider-status",
  authMiddleware,
  getProviderStatus
);
// Upload Shop Logo
router.post(
  "/upload-logo",
  authMiddleware,
  upload.single("image"),
  uploadShopLogo
);
module.exports = router;