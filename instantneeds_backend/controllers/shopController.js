const Shop = require("../models/Shop");
const User = require("../models/User");
const cloudinary = require("../config/cloudinary");
const streamifier = require("streamifier");
function getDistance(lat1, lon1, lat2, lon2) {
  const R = 6371;

  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;

  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(lat1 * Math.PI / 180) *
      Math.cos(lat2 * Math.PI / 180) *
      Math.sin(dLon / 2) ** 2;

  const c = 2 * Math.atan2(
    Math.sqrt(a),
    Math.sqrt(1 - a)
  );

  return R * c;
}

// Register Shop
exports.registerShop = async (req, res) => {
   console.log("========== REGISTER SHOP ==========");
    console.log(req.user);
    console.log(req.body);
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
exports.getNearbyShops = async (req, res) => {
  try {
    const { category, latitude, longitude } = req.query;

    let filter = {};

    if (category) {
      filter.category = {
        $regex: `^${category}$`,
        $options: "i",
      };
    }

    let shops = await Shop.find(filter).select("-__v");

    if (latitude && longitude) {
      const userLat = Number(latitude);
      const userLng = Number(longitude);

      shops = shops.filter((shop) => {
        if (!shop.latitude || !shop.longitude) return false;

        const distance = getDistance(
          userLat,
          userLng,
          shop.latitude,
          shop.longitude,
        );

        shop._doc.distance = distance.toFixed(2);

        return distance <= 10; // 10 KM
      });

      shops.sort((a, b) => a.distance - b.distance);
    }

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

// Get Provider Status
exports.getProviderStatus = async (req, res) => {
  try {
    const shop = await Shop.findOne({
      ownerId: req.user.id,
    });

    if (!shop) {
      return res.json({
        registered: false,
      });
    }

    return res.json({
      registered: true,
      verified: shop.isVerified,
      shopName: shop.shopName,
    });

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};
// Upload Shop Logo
exports.uploadShopLogo = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: "No image selected",
      });
    }

    const shop = await Shop.findOne({
      ownerId: req.user.id,
    });

    if (!shop) {
      return res.status(404).json({
        success: false,
        message: "Shop not found",
      });
    }

    const uploadStream = cloudinary.uploader.upload_stream(
  {
    folder: "instantneeds/shop_logo",
  },
  async (error, result) => {

    console.log("File Received:", req.file);
    console.log("Cloudinary Error:", error);
    console.log("Cloudinary Result:", result);
    console.log("Cloudinary URL:", result?.secure_url);

    if (error) {
      return res.status(500).json({
        success: false,
        message: error.message,
      });
    }

    shop.shopLogo = result.secure_url;

    await shop.save();

    console.log("Saved shopLogo:", shop.shopLogo);

    res.json({
      success: true,
      message: "Shop Logo Uploaded Successfully",
      logo: result.secure_url,
    });
  }
);
    streamifier
      .createReadStream(req.file.buffer)
      .pipe(uploadStream);

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
}
