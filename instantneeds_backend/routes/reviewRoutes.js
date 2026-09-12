const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/authMiddleware");

const {
  submitReview,
  getProviderReviews,
  getAverageRating,
} = require("../controllers/reviewController");

// Customer submits a review
router.post(
  "/",
  authMiddleware,
  submitReview
);

// Get all reviews of a provider
router.get(
  "/provider/:providerId",
  getProviderReviews
);

// Get provider average rating
router.get(
  "/provider/:providerId/average",
  getAverageRating
);

module.exports = router;