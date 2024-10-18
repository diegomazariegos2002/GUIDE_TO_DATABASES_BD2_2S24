const app = require('./app.js');
require('dotenv').config();
const port = process.env.API_PORT;
const db = require('./database');

Promise.all([db.getInstanceRedis(), db.getMongoConnectionPromise()])
  .then(() => {
    app.listen(port, () => {
      console.log(`Server running on http://localhost:${port}`);
    });
  })
  .catch(err => {
    console.error('Connection error:', err);
    process.exit(1);
  });
