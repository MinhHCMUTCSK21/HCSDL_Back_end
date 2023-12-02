const config = {
  user: "sa",
  password: "Password.1",
  server: "localhost",
  database: "btlfinal",
  options: {
    trustServerCertificate: true,
    trustedConnection: false,
    enableArithAbort: true,
    instancename: "SQLEXPRESS",
  },
  port: 1433,
};

module.exports = config;
