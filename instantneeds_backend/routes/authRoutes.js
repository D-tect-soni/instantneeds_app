const express = require("express");
const upload = require("../middleware/uploadMiddleware");
const {
  register,
  login,
  getProfile,
  updateProfile,
  uploadProfileImage,
  forgotPassword,
  verifyOTP,
  resetPassword,
} = require("../controllers/authController");
const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

router.post("/register", register);

router.post("/login", login);
router.get(
  "/profile",
  authMiddleware,
  getProfile
);
router.put(
  "/profile",
  authMiddleware,
  updateProfile
);

router.post(
  "/upload-profile-image",
  authMiddleware,
  upload.single("image"),
  uploadProfileImage,
);
router.post("/forgot-password", forgotPassword);
router.post("/verify-otp", verifyOTP);
router.post("/reset-password", resetPassword);

module.exports = router;