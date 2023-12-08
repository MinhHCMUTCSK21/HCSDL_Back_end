const express = require("express");
const cors = require("cors");
const DAO = require("./DAO");
const app = express();

app.use(cors());
app.use(express.json());

app.get("/staff", async (req, res) => {
  try {
    const data = await DAO.getStaff();
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});

app.post("/staff", async (req, res) => {
  try {
    const data = await DAO.postStaff(req.body.staff);
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.patch("/staff", async (req, res) => {
  try {
    const data = await DAO.updateStaff(req.body.staff);
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});

app.delete("/staff", async (req, res) => {
  try {
    const data = await DAO.deleteStaff(req.query.staff_id);
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});

app.get("/managers", async (req, res) => {
  try {
    const data = await DAO.getManagers();
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});

app.get("/restaurant", async (req, res) => {
  try {
    const data = await DAO.getRestaurant();
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});

app.get("/reservedTable", async (req, res) => {
  try {
    const data = await DAO.getReservedTable();
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.post("/reservation", async (req, res) => {
  try {
    const data = await DAO.bookReservation(req.body.reservation);
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.get("/table", async (req, res) => {
  try {
    const data = await DAO.getTable();
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.post("/table", async (req, res) => {
  try {
    const data = await DAO.insertTable(req.body.table);
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.delete("/table", async (req, res) => {
  try {
    const data = await DAO.deleteTable(req.query.table_id, req.query.res_id);
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});

app.post("/bill/create_bill", async (req, res) => {
  try {
    const data = await DAO.createBill(req.body.bill);
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.get("/food", async (req, res) => {
  try {
    const data = await DAO.getFood();
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});
app.get("/customer", async (req, res) => {
  try {
    const data = await DAO.getCustomer();
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.post("/customer", async (req, res) => {
  try {
    const data = await DAO.insertCustomer(req.body.customer);
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.get("/acc", async (req, res) => {
  try {
    const data = await DAO.getAcc();
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.post("/acc", async (req, res) => {
  try {
    const data = await DAO.createAcc(req.body.account);
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.post("/bill/add", async (req, res) => {
  try {
    const data = await DAO.addFood(req.body.dish_included);
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});
app.patch("/bill/update", async (req, res) => {
  try {
    const data = await DAO.updateFoodCount(req.body.dish_included);
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});
app.delete("/bill/delete", async (req, res) => {
  try {
    const data = await DAO.deleteFood(req.body.dish_included);
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});
app.get("/bill", async (req, res) => {
  try {
    const data = await DAO.getBill();
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});
app.get("/bill_1", async (req, res) => {
  try {
    const data = await DAO.getOneBill(req.query.bill_id);
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});
app.patch("/bill", async (req, res) => {
  try {
    const data = await DAO.updatePay(req.query.bill_id);
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});
app.get("/dish_included", async (req, res) => {
  try {
    const data = await DAO.getDishIncluded(req.query.bill_id);
    res.json({ success: true, data: data });
  } catch (err) {
    res.json({ success: false, data: err });
  }
});

app.get("/promo", async (req, res) => {
  try {
    const data = await DAO.getPromo(req.query.bill_id);
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.get("/promotions", async (req, res) => {
  try {
    const data = await DAO.getPromotions();
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.get("/staff_age", async (req, res) => {
  try {
    const data = await DAO.getEmployeeIn(req.query.agemin, req.query.agemax);
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.get("/customer_pay", async (req, res) => {
  try {
    const data = await DAO.getCustomerIn(
      req.query.month,
      req.query.year,
      req.query.money
    );
    res.json({ success: true, data: data });
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});
app.get("/best_seller", async (req, res) => {
  try {
    const data = await DAO.getBestSeller(req.query.month, req.query.year);

    if (data.length > 0) {
      res.json({ success: true, data: data[0].bestSeller });
    } else {
      res.json({ success: true, data: "There is no best seller!" });
    }
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.get("/revenue", async (req, res) => {
  try {
    const data = await DAO.revenueStat(req.query.year, req.query.res_id);
    if (data.length > 0) {
      res.json({ success: true, data: data[0].result });
    } else {
      res.json({ success: true, data: "There is no revenue!" });
    }
  } catch (err) {
    console.log(err);
    res.json({ success: false, data: err });
  }
});

app.listen(3000, () => {
  console.log("server started");
});
