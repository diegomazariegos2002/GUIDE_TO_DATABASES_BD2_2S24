const db = require('../database')
const MovieModel = require('../models/movieModel')

class MovieController {
    constructor() { }

    index(req, res) {
        res.status(200).json({ message: 'This is the landing page NodeJs - Peliculas' });
    }

    async listMovies(req, res) {
        try {
            const movies = await MovieModel.getAllMovies();
            res.status(200).json(movies);
        } catch (error) {
            res.status(500).json({ message: 'Error retrieving the movies', error: error.message });
        }
    }

    createMovie(req, res) {
        const movieData = req.body;
        try {
            const movieId = `movie:${Date.now()}`;
            const movie = new MovieModel(movieData);
            movie.createMovie(movieId, movieData);
            res.status(201).json({ message: 'Movie created', id: movieId });
        } catch (error) {
            res.status(400).json({ message: error.message });
        }
    }

    async readMovie(req, res) {
        const movieId = req.params.id;
        try {
            const movie = await MovieModel.getMovie(movieId);
            if (movie && Object.keys(movie).length) {
                res.status(200).json(movie);
            } else {
                res.status(404).json({ message: 'Movie not found' });
            }
        } catch (err) {
            res.status(500).json({ message: 'Error retrieving the movie', error: err.message });
        }
    }

    updateMovie(req, res) {
        const movieId = req.params.id;
        const { Title, Year, Genre, Rating, Country, Principal_Language, Director_name, Clasification, Price } = req.body;
        const updateData = {
            ...(Title && { Title }),
            ...(Year && { Year }),
            ...(Genre && { Genre }),
            ...(Rating && { Rating }),
            ...(Country && { Country }),
            ...(Principal_Language && { Principal_Language }),
            ...(Director_name && { Director_name }),
            ...(Clasification && { Clasification }),
            ...(Price && { Price })
        };

        MovieModel.updateMovie(movieId, updateData);
        res.status(200).json({ message: 'Movie updated', id: movieId });
    }

    deleteMovie(req, res) {
        const movieId = req.params.id;
        MovieModel.deleteMovie(movieId);
        res.status(200).json({ message: 'Movie deleted', id: movieId });
    }

    async getMoviesByGenre(req, res) {
        const genre = req.params.genre;
        try {
            console.log('entro')
            const movies = await MovieModel.getMoviesByGenre(genre);
            res.status(200).json(movies);
        } catch (error) {
            console.log(error)
            res.status(500).json({ message: 'Error retrieving the movies', error: error.message });
        }
    }

    async getMoviesByRClasificationOrHigh(req, res) {
        try {
            const movies = await MovieModel.getMoviesByRClasificationOrHigh();
            res.status(200).json(movies);
        } catch (error) {
            console.log(error)
            res.status(500).json({ message: 'Error retrieving the movies', error: error.message });
        }
    }

    async getMoviesByDirector(req, res) {
        const director = req.params.director;
        try {
            const movies = await MovieModel.getMoviesByDirector(director);
            res.status(200).json(movies);
        } catch (error) {
            console.log(error)
            res.status(500).json({ message: 'Error retrieving the movies', error: error.message });
        }
    }

    async getMoviesWithPriceLowerThan10(req, res) {
        try {
            const movies = await MovieModel.getMoviesWithPriceLowerThan10();
            res.status(200).json(movies);
        } catch (error) {
            console.log(error)
            res.status(500).json({ message: 'Error retrieving the movies', error: error.message });
        }
    }

    async getMoviesByYear(req, res) {
        const year = req.params.year;
        try {
            const movies = await MovieModel.getMoviesByYear(year);
            res.status(200).json(movies);
        } catch (error) {
            console.log(error)
            res.status(500).json({ message: 'Error retrieving the movies', error: error.message });
        }
    }

    async getMoviesPriceAverage(req, res) {
        try {
            const average = await MovieModel.getMoviesPriceAverage();
            res.status(200).json(average);
        } catch (error) {
            console.log(error)
            res.status(500).json({ message: 'Error retrieving the movies', error: error.message });
        }
    }

    async getMoviesPriceAverageByGenre(req, res) {
        const genre = req.params.genre;
        try {
            const average = await MovieModel.getMoviesPriceAverageByGenre(genre);
            res.status(200).json(average);
        } catch (error) {
            console.log(error)
            res.status(500).json({ message: 'Error retrieving the movies', error: error.message });
        }
    }

    async getMoviesByKeyword(req, res) {
        const keyword = req.params.keyword;
        try {
            const movies = await MovieModel.searchMoviesByKeyword(keyword);
            res.status(200).json(movies);
        } catch (error) {
            console.log(error)
            res.status(500).json({ message: 'Error retrieving the movies', error: error.message });
        }
    }
}

module.exports = new MovieController();
