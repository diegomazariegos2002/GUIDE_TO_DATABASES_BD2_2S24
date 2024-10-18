const db = require('../database');

class MovieModel {
  constructor(data) {
    if (data !== null || data !== undefined) {
      const { Title, Year, Genre, Rating, Country, Principal_Language, Director_name, Clasification, Price } = data;
      this.Title = Title;
      this.Year = Year;
      this.Genre = Genre;
      this.Rating = Rating;
      this.Country = Country;
      this.Principal_Language = Principal_Language;
      this.Director_name = Director_name;
      this.Clasification = Clasification;
      this.Price = Price;
    } else {
      // Handle null data, maybe assign default values or throw an error
      this.Title = '';
      this.Year = '';
      this.Genre = '';
      this.Rating = '';
      this.Country = '';
      this.Principal_Language = '';
      this.Director_name = '';
      this.Clasification = '';
      this.Price = '';
    }
  }

  validate() {
    return this.Year && this.Genre && this.Rating && this.Country && this.Principal_Language &&
      this.Director_name && this.Clasification && this.Price;
  }

  toRedisHash() {
    return {
      Title: this.Title,
      Year: this.Year.toString(),
      Genre: this.Genre,
      Rating: this.Rating.toString(),
      Country: this.Country,
      Principal_Language: this.Principal_Language,
      Director_name: this.Director_name,
      Clasification: this.Clasification,
      Price: this.Price.toString()
    };
  }

  static async getAllMovies() {
    const client = await db.getInstanceRedis();
    try {
      const keys = await client.keys('movie:*');
      let movies = await Promise.all(keys.map(key => client.hGetAll(key)));
      // Convertimos los campos a su tipo original
      movies = movies.map(movie => {
        return {
          ...movie,
          Year: parseInt(movie.Year, 10),
          Rating: parseFloat(movie.Rating),
          Price: parseFloat(movie.Price)
        };
      });
      return movies;
    } catch (err) {
      console.error('Error retrieving all movies from Redis:', err);
      throw err;
    }
  }

  async createMovie() {
    if (!this.validate()) {
      throw new Error('Validation failed');
    }
    const hash = this.toRedisHash();
    const client = await db.getInstanceRedis();
    const movieId = `movie:${Date.now()}`; // Generamos un ID único para la nueva película

    try {
      await client.hSet(movieId, hash);
      // añadiendo Indexs
      await client.sAdd(`index:genre:${this.Genre}`, movieId);
      await client.sAdd(`index:year:${this.Year}`, movieId);
      await client.sAdd(`index:rating:${this.Rating}`, movieId);
      await client.sAdd(`index:country:${this.Country}`, movieId);
      await client.sAdd(`index:language:${this.Principal_Language}`, movieId);
      await client.sAdd(`index:director:${this.Director_name}`, movieId);
      await client.sAdd(`index:clasification:${this.Clasification}`, movieId);

      // Añadiendo al conjunto ordenado de precios
      await client.zAdd(`index:price`, { score: this.Price, value: movieId });

      console.log('Movie created with ID:', movieId);
      return movieId;
    } catch (err) {
      console.error('Error creating movie in Redis:', err);
      throw err;
    }
  }

  static async getMovie(id) {
    const client = await db.getInstanceRedis();
    try {
      let movie = await client.hGetAll(id);

      // Verificar que la película existe antes de intentar convertir los tipos de datos.
      if (Object.keys(movie).length > 0) {
        movie = {
          ...movie,
          Year: parseInt(movie.Year, 10),
          Rating: parseFloat(movie.Rating),
          Price: parseFloat(movie.Price)
        };
      }

      return movie;
    } catch (err) {
      console.error('Error getting movie from Redis:', err);
      throw err;
    }
  }

  static async updateMovie(id, updateData) {
    const client = await db.getInstanceRedis();
    try {
      const movie = await client.hGetAll(id);
      if (Object.keys(movie).length === 0) {
        throw new Error('Movie not found');
      }

      const updatedMovie = { ...movie, ...updateData };
      await client.hSet(id, updatedMovie);
      console.log('Movie updated with ID:', id);
      return updatedMovie;
    } catch (err) {
      console.error('Error updating movie in Redis:', err);
      throw err;
    }
  }

  static async deleteMovie(id) {
    const client = await db.getInstanceRedis();
    try {
      await client.del(id);
      console.log('Movie deleted with ID:', id);
      return true;
    } catch (err) {
      console.error('Error deleting movie from Redis:', err);
      throw err;
    }
  }

  static async getMoviesByGenre(genre) {
    const client = await db.getInstanceRedis();
    console.log('sMembers' in client && typeof client.sMembers === 'function'); // Should log true if smembers is a function
    console.log('hGetAll' in client && typeof client.hGetAll === 'function'); // Should log true if hGetAll is a function
    const ids = await client.sMembers(`index:genre:${genre}`);
    const movies = [];
    for (const id of ids) {
      const movie = await client.hGetAll(id);
      movies.push(movie);
    }
    return movies;
  }

  static async getMoviesByRClasificationOrHigh() {
    const client = await db.getInstanceRedis();
    try {
      console.log("entro")
      const ids = await client.sMembers('index:clasification:R');
      // Aquí agregarías las clasificaciones consideradas superiores a "R"
      const higherClassifications = ['NC-17']; // Ejemplo de clasificaciones superiores a R
      for (const classification of higherClassifications) {
        const moreIds = await client.sMembers(`index:clasification:${classification}`);
        ids.push(...moreIds);
      }

      let movies = await Promise.all(ids.map(id => client.hGetAll(id)));

      // Convertir a los tipos correctos, ya que Redis devuelve todo como strings
      movies = movies.map(movie => ({
        ...movie,
        Year: parseInt(movie.Year, 10),
        Rating: parseFloat(movie.Rating),
        Price: parseFloat(movie.Price)
      }));

      return movies;
    } catch (err) {
      console.error('Error retrieving movies by R classification or higher:', err);
      throw err;
    }
  }

  static async getMoviesByDirector(director) {
    const client = await db.getInstanceRedis();
    const ids = await client.sMembers(`index:director:${director}`);
    const movies = [];
    for (const id of ids) {
      const movie = await client.hGetAll(id);
      movies.push(movie);
    }
    return movies;
  }

  static async getMoviesWithPriceLowerThan10() {
    const client = await db.getInstanceRedis();
    try {
      // Recuperar todas las películas con un precio menor a 10
      // ZRANGEBYSCORE obtiene los elementos con un score (precio) dentro del rango dado
      const movieIdsWithScores = await client.zRangeByScore('index:price', '-inf', 10, 'WITHSCORES');

      const movies = [];
      // movieIdsWithScores contiene una lista de la forma [id1, score1, id2, score2, ...]
      for (let i = 0; i < movieIdsWithScores.length; i ++) {
        const movieId = movieIdsWithScores[i];
        const movie = await client.hGetAll(movieId);
        // Convertir a los tipos correctos, ya que Redis devuelve todo como strings
        if (movie.Price && parseFloat(movie.Price) < 10) {
          movies.push({
            ...movie,
            Year: parseInt(movie.Year, 10),
            Rating: parseFloat(movie.Rating),
            Price: parseFloat(movie.Price)
          });
        }
      }
      return movies;
    } catch (err) {
      console.error('Error retrieving movies with price lower than 10:', err);
      throw err;
    }
  }

  static async getMoviesByYear(year) {
    const client = await db.getInstanceRedis();
    try {
      // Obtener todos los IDs de películas del año específico
      const movieIds = await client.sMembers(`index:year:${year}`);
      const movies = [];
  
      // Obtener la información de cada película usando su ID
      for (const movieId of movieIds) {
        const movie = await client.hGetAll(movieId);
        // Convertir a los tipos correctos, ya que Redis devuelve todo como strings
        movies.push({
          ...movie,
          Year: parseInt(movie.Year, 10),
          Rating: parseFloat(movie.Rating),
          Price: parseFloat(movie.Price)
        });
      }
  
      return movies;
    } catch (err) {
      console.error('Error retrieving movies from year:', year, err);
      throw err;
    }
  }  

  static async getMoviesPriceAverage() {
    const client = await db.getInstanceRedis();
    try {
      // Obtener todos los IDs de películas
      const keys = await client.keys('movie:*');
      let totalSum = 0;
      let count = 0;
  
      // Obtener los precios de cada película y sumarlos
      for (const key of keys) {
        const movie = await client.hGetAll(key);
        if (movie && movie.Price) {
          totalSum += parseFloat(movie.Price);
          count++;
        }
      }
  
      // Calcular el promedio
      const average = count > 0 ? totalSum / count : 0;
      return average;
    } catch (err) {
      console.error('Error retrieving the average movie price:', err);
      throw err;
    }
  }
  
  static async getMoviesPriceAverageByGenre(genre) {
    const client = await db.getInstanceRedis();
    try {
      // Obtener todos los IDs de películas para un género específico
      const movieIds = await client.sMembers(`index:genre:${genre}`);
      let totalSum = 0;
      let movieCount = 0;
  
      // Sumar los precios de las películas y contarlas
      for (const movieId of movieIds) {
        const movie = await client.hGetAll(movieId);
        if (movie.Price) {
          totalSum += parseFloat(movie.Price);
          movieCount++;
        }
      }
  
      // Calcular el promedio de precios para el género
      const averagePrice = movieCount > 0 ? totalSum / movieCount : 0;
      return averagePrice;
    } catch (err) {
      console.error('Error retrieving the average price for genre:', genre, err);
      throw err;
    }
  }

  static async searchMoviesByKeyword(keyword) {
    const client = await db.getInstanceRedis();
    try {
      const keys = await client.keys('movie:*');
      let movies = await Promise.all(keys.map(key => client.hGetAll(key)));
      // Filtrar películas por palabra clave en el título
      movies = movies.filter(movie => movie.Title && movie.Title.toLowerCase().includes(keyword.toLowerCase()));
      return movies;
    } catch (err) {
      console.error('Error searching movies by keyword:', err);
      throw err;
    }
  }
  
}
module.exports = MovieModel;
