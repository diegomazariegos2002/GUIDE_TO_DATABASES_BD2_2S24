const express = require('express');
const router = express.Router();

const movieController = require('../controllers/movieController');

router.get('/index', movieController.index);
router.get('/', movieController.listMovies);
router.post('/', movieController.createMovie);
router.get('/:id', movieController.readMovie);
router.put('/:id', movieController.updateMovie);
router.delete('/:id', movieController.deleteMovie);
router.get('/genre/:genre', movieController.getMoviesByGenre);
router.get('/by/RClasification-or-High', movieController.getMoviesByRClasificationOrHigh);
router.get('/by/Director/:director', movieController.getMoviesByDirector);
router.get('/by/PriceLowerThan10', movieController.getMoviesWithPriceLowerThan10);
router.get('/by/Year/:year', movieController.getMoviesByYear);
router.get('/Price/Average', movieController.getMoviesPriceAverage);
router.get('/Price/Average/Genre/:genre', movieController.getMoviesPriceAverageByGenre);
router.get('/by/Keyword/:keyword', movieController.getMoviesByKeyword);

module.exports = router;
