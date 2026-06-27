require("dns").setServers(["8.8.8.8", "8.8.4.4"]);
require("dotenv").config();

console.log("MONGO_URI =", process.env.MONGO_URI);

const express = require("express");
const cors = require("cors");

const connectDB = require("./config/db");
const authRoutes = require("./routes/authRoutes");
const orderRoutes = require("./routes/orderRoutes");
const shopRoutes = require("./routes/shopRoutes");
const app = express();

connectDB();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/shop", shopRoutes);

app.get("/", (req, res) => {
  res.send("InstantNeeds API Running");
});

app.listen(5000, "0.0.0.0", () => {
  console.log("🚀 Server Running on Port 5000");
});