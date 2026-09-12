require("dns").setServers(["8.8.8.8", "8.8.4.4"]);
require("dotenv").config();

console.log("MONGO_URI =", process.env.MONGO_URI);

const express = require("express");
const cors = require("cors");

const connectDB = require("./config/db");
const authRoutes = require("./routes/authRoutes");
const orderRoutes = require("./routes/orderRoutes");
const shopRoutes = require("./routes/shopRoutes");
const reviewRoutes = require("./routes/reviewRoutes");
const app = express();
const PORT = process.env.PORT || 5000;
connectDB();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/shop", shopRoutes);
app.use("/api/reviews", reviewRoutes);

app.get("/", (req, res) => {
  res.send("InstantNeeds API Running");
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server Running on http://0.0.0.0:${PORT}`);
});