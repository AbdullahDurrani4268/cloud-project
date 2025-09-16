const express = require("express");
const app = express();
const port = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.send("Hello from Node.js app!");
});

app.get("/health", (req, res) => {
  res.json({ status: "UP" });
});

app.listen(port, () => {
  console.log(`Node app running on port ${port}`);
});
