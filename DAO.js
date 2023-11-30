const config = require("./config/config");
const sql = require("mssql");

const getStaff = async () => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`SELECT * FROM staff `);
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const postStaff = async (staff) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
    EXECUTE Add_staff '${staff.identification}', N'${staff.name}', ${staff.gender}, '${staff.date_of_birth}', ${staff.manager_id}, N'${staff.province}', N'${staff.district}', N'${staff.ward}', N'${staff.address_number}', '${staff.res_id}','${staff.email}', '${staff.phone_number}', '${staff.accID}'
    `);
    return "Inserted staff";
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};
const checkNull = (value) => {
  if (value == "NULL") return "NULL";
  else return `N'${value}'`;
};
const updateStaff = async (staff) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
    EXECUTE Update_staff_by_id ${staff.id}, ${
      staff.identification
    }, ${checkNull(staff.name)}, ${staff.gender}, ${staff.date_of_birth}, ${
      staff.manager_id
    }, ${checkNull(staff.province)},${checkNull(staff.district)} ,${checkNull(
      staff.ward
    )}, ${checkNull(staff.address_number)}, ${staff.res_id}, ${staff.accID}`);
    return "Updated staff";
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const deleteStaff = async (staff_id) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool
      .request()
      .query(`EXECUTE Delete_staff_by_id ${staff_id}`);
    return "Deleted staff";
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const getManagers = async () => {
  try {
    const pool = await sql.connect(config);
    const result = await pool
      .request()
      .query(
        `SELECT staff.* FROM staff WHERE staff.staff_id IN (SELECT manager_id FROM staff WHERE manager_id IS NOT NULL ) `
      );
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const getRestaurant = async () => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`SELECT * FROM restaurant `);
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const insertTable = async (table) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
        INSERT INTO r_table
        VALUES
	    ('${table.res_id}', '${table.table_id}', ${table.slot_count});`);
    return "Inserted ";
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const deleteTable = async (table_id, res_id) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
          DELETE FROM r_table
          WHERE table_id = '${table_id}' AND res_id = '${res_id}'`);
    return "Deleted ";
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const createBill = async (bill) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
          INSERT INTO bill
           VALUES
          ('${bill.bill_id}', convert(datetime,'${bill.bill_datetime}',120), 0, '${bill.res_id}', '${bill.table_id}', '${bill.cus_id}', null);`);
    return "Create bill successfully";
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const getFood = async () => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`SELECT * FROM dish`);
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const getCustomer = async () => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`SELECT * FROM customer`);
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const insertCustomer = async (cus) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
      INSERT INTO customer
      VALUES
	('${cus.id}', N'${cus.name}', '${cus.phone}', '${cus.accID}', null);`);
    return "Inserted customer";
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const getAcc = async () => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`SELECT * FROM account`);
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const addFood = async (dish_included) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
        INSERT INTO dish_isincluded_bill
        VALUES
        ('${dish_included.bill_id}', '${dish_included.dish_id}', '${dish_included.count}', 0)`);
    return "Add food successfully";
  } catch (err) {
    console.log(err);
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const getBill = async () => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`SELECT * FROM bill`);
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const getDishIncluded = async (bill_id) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool
      .request()
      .query(
        `SELECT dish_isincluded_bill.*, dish.dish_name FROM dish_isincluded_bill, dish WHERE bill_id = '${bill_id}' AND dish_isincluded_bill.dish_id = dish.dish_id`
      );
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};
const getOneBill = async (bill_id) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request()
      .query(`SELECT * FROM bill WHERE bill_id = '${bill_id}'
`);
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};
const updateFoodCount = async (dish_included) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
            UPDATE dish_isincluded_bill
            SET dish_count = ${dish_included.count}
            WHERE bill_id = '${dish_included.bill_id}' AND dish_id = '${dish_included.dish_id}'`);
    return "Update food count successfully";
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const updatePay = async (bill_id) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
            UPDATE bill
            SET pay_status = '1'
            WHERE bill_id = '${bill_id}'`);
    return "Update payment successfully";
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const deleteFood = async (dish_included) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool.request().query(`
                DELETE FROM dish_isincluded_bill
                WHERE bill_id = '${dish_included.bill_id}' AND dish_id = '${dish_included.dish_id}'`);
    return "Delete food successfully";
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const getPromo = async (bill_id) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool
      .request()
      .query(
        `SELECT promotion.* FROM promotion , prom_applies_bill WHERE promotion.promotion_id = prom_applies_bill.promotion_id AND prom_applies_bill.bill_id='${bill_id}'`
      );
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const getEmployeeIn = async (agemin, agemax) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool
      .request()
      .query(`exec [dbo].[staff_age_in_range] ${agemin}, ${agemax}`);
    console.log(result);
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const getCustomerIn = async (month, year, money) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool
      .request()
      .query(`exec [dbo].[customer_expense] ${month}, ${year}, ${money}`);
    console.log(result);
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const getBestSeller = async (month, year) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool
      .request()
      .query(
        `select dbo.most_fav_dish('${month}','${year}') as N'Món ăn yêu thích nhất'`
      );
    console.log(result);
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

const revenueStat = async (year, res_id) => {
  try {
    const pool = await sql.connect(config);
    const result = await pool
      .request()
      .query(
        `select [dbo].[income_in_year] ('${year}','${res_id}') AS 'Result'`
      );
    console.log(result);
    return result.recordset;
  } catch (err) {
    throw err.originalError.info.message;
  } finally {
    sql.close();
  }
};

module.exports = {
  getStaff,
  postStaff,
  updateStaff,
  deleteStaff,
  getManagers,
  getRestaurant,
  insertTable,
  deleteTable,
  createBill,
  getFood,
  getCustomer,
  insertCustomer,
  getAcc,
  addFood,
  getBill,
  getDishIncluded,
  updateFoodCount,
  getOneBill,
  updatePay,
  deleteFood,
  getPromo,
  getEmployeeIn,
  getCustomerIn,
  getBestSeller,
  revenueStat,
};
