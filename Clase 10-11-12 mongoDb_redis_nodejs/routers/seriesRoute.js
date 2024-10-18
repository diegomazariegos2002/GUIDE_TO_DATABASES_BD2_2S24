const express = require('express');
const router = express.Router();
const SeriesController = require('../controllers/seriesController');

// Ruta para buscar las series por genero
router.get('/series-by-genre/:genero', SeriesController.buscarSeriesPorGenero.bind(SeriesController));

// Ruta para mostrar las series con mas de dos temporadas
router.get('/series-seasons', SeriesController.mostrarSeriesConMasDeDosTemporadas.bind(SeriesController));

// Ruta para obtener las series de una temporada actual en especifico
router.get('/current-season/:season', SeriesController.encontrarSeriesPorTemporadaActual.bind(SeriesController));

// Ruta para listar todas las series con un precio inferior a 10
router.get('/lower-price', SeriesController.buscarSeriesConPrecioInferior.bind(SeriesController));

// Ruta para buscar una serie por el año
router.get('/series-by-year/:anio', SeriesController.buscarSeriesPorAño.bind(SeriesController));

// Ruta para calcular el promedio de precio
router.get('/series-price-average', SeriesController.calcularPromedioPrecioSeries.bind(SeriesController));

// Ruta para ordenar las series por rating
router.get('/series-by-rating-sorted', SeriesController.obtenerSeriesOrdenadasPorRating.bind(SeriesController));

// RUta para busqueda parcial de series
router.get('/keyword-search/:keyword', SeriesController.buscarSeriesPorPalabraClave.bind(SeriesController));

// Ruta para guardar una serie
router.post('/guardarSerie', SeriesController.guardarSerie.bind(SeriesController));

// Ruta para obtener una serie por su ID
router.get('/:id', SeriesController.obtenerSeriePorId.bind(SeriesController));

// Ruta para actualizar una serie por su ID
router.put('/:id', SeriesController.actualizarSerie.bind(SeriesController));

// Ruta para eliminar una serie por su ID
router.delete('/:id', SeriesController.eliminarSerie.bind(SeriesController));

// Ruta para listar todas las series
router.get('/', SeriesController.listarSeries.bind(SeriesController));

module.exports = router;
