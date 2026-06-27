const Shop = require("../models/Shop");
const User = require("../models/User");

// Register Shop
exports.registerShop = async (req, res) => {
  try {
    const {
      shopName,
      category,
      phone,
      address,
      city,
      state,
      pincode,
      description,
      experience,
      openingTime,
      closingTime,
      latitude,
      longitude,
    } = req.body;

    // Check if shop already exists for this user
    const existingShop = await Shop.findOne({
      ownerId: req.user.id,
    });

    if (existingShop) {
      return res.status(400).json({
        message: "Shop already registered",
      });
    }

    // Create Shop
    const shop = await Shop.create({
      ownerId: req.user.id,
      shopName,
      category,
      phone,
      address,
      city,
      state,
      pincode,
      description,
      experience,
      openingTime,
      closingTime,
      latitude,
      longitude,
    });

    // Update user role
    await User.findByIdAndUpdate(req.user.id, {
      role: "provider",
    });

    res.status(201).json({
      message: "Shop Registered Successfully",
      shop,
    });

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

// Get My Shop
exports.getMyShop = async (req, res) => {
  try {
    const shop = await Shop.findOne({
      ownerId: req.user.id,
    });

    if (!shop) {
      return res.status(404).json({
        message: "Shop not found",
      });
    }

    res.json(shop);

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

// Get Verified Shops
exports.getVerifiedShops = async (req, res) => {
  try {
    const shops = await Shop.find({
      isVerified: true,
    });

    res.json(shops);

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};
// Update Shop
exports.updateShop = async (req, res) => {
  try {
    const shop = await Shop.findOne({
      ownerId: req.user.id,
    });

    if (!shop) {
      return res.status(404).json({
        message: "Shop not found",
      });
    }

    Object.assign(shop, req.body);

    await shop.save();

    res.json({
      message: "Shop Updated Successfully",
      shop,
    });

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};
// Get Nearby Shops
exports.getNearbyShops = async (req, res) => {
  try {
    const { category, city } = req.query;

    let filter = {
      isVerified: true,
    };

    if (category) {
      filter.category = category;
    }

    if (city) {
      filter.city = city;
    }

    const shops = await Shop.find(filter)
      .select("-__v")
      .sort({ rating: -1 });

    res.json({
      success: true,
      total: shops.length,
      shops,
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};