import express from "express";
import client from "prom-client";

const app = express();
const port = Number(process.env.PORT || 8080);

client.collectDefaultMetrics();

app.get("/", (_req, res) => {
  res.json({
    app: "__APP_NAME__",
    status: "ok"
  });
});

app.get("/healthz", (_req, res) => {
  res.json({
    status: "healthy"
  });
});

app.get("/metrics", async (_req, res) => {
  res.set("Content-Type", client.register.contentType);
  res.end(await client.register.metrics());
});

app.listen(port, "0.0.0.0", () => {
  console.log(`__APP_NAME__ listening on port ${port}`);
});
