const Review = require("../models/review");
const Order = require("../models/Order");
const Shop = require("../models/Shop");


// ==========================
// Submit Review
// ==========================
exports.submitReview = async (req, res) => {
  try {
    const { orderId, providerId, rating, review } = req.body;

    // Check Order
    const order = await Order.findById(orderId);

    if (!order) {
      return res.status(404).json({
        success: false,
        message: "Order not found",
      });
    }

    // Only completed orders
    if (order.orderStatus !== "Completed") {
      return res.status(400).json({
        success: false,
        message: "Review can only be submitted after order completion.",
      });
    }

    // Check duplicate review
    const existingReview = await Review.findOne({ orderId });

    if (existingReview) {
      return res.status(400).json({
        success: false,
        message: "Review already submitted.",
      });
    }

    // Save Review
    const newReview = await Review.create({
      orderId,
      providerId,
      customerId: req.user.id,
      rating,
      review,
    });

    // Calculate new average rating
    const reviews = await Review.find({ providerId });

    const totalRating = reviews.reduce(
      (sum, item) => sum + item.rating,
      0
    );

    const averageRating = totalRating / reviews.length;

    // Update Shop Rating
    await Shop.findOneAndUpdate(
      { ownerId: providerId },
      {
        rating: averageRating.toFixed(1),
      }
    );

    res.status(201).json({
      success: true,
      message: "Review submitted successfully.",
      review: newReview,
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};



// ==========================
// Get Provider Reviews
// ==========================
exports.getProviderReviews = async (req, res) => {
  try {

    const reviews = await Review.find({
      providerId: req.params.providerId,
    })
      .populate("customerId", "name")
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      totalReviews: reviews.length,
      reviews,
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};



// ==========================
// Get Average Rating
// ==========================
exports.getAverageRating = async (req, res) => {
  try {

    const reviews = await Review.find({
      providerId: req.params.providerId,
    });

    if (reviews.length === 0) {
      return res.json({
        average: 0,
        totalReviews: 0,
      });
    }

    const total = reviews.reduce(
      (sum, review) => sum + review.rating,
      0
    );

    res.json({
      average: (total / reviews.length).toFixed(1),
      totalReviews: reviews.length,
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};