const bodyParser = require('body-parser');
const express = require('express');
const cors = require('cors');
const app = express();
const morgan = require('morgan');

const mainRoute = require('./routers/mainRoute');
const seriesRoutes = require('./routers/seriesRoute');
const movieRoute = require('./routers/movieRoute');

//middleware
app.use(morgan('dev'));

app.use(bodyParser.json({ limit: '10mb' }));
app.use(express.json());
app.use(cors());

app.use('/', mainRoute);
app.use('/serie', seriesRoutes);
app.use('/pelicula', movieRoute);

module.exports = app;