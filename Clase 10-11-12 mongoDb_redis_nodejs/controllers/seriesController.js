const mongoose = require('mongoose');
require('dotenv').config();

const serieSchema = new mongoose.Schema({
    Title: String,
    Year: Number,
    Genre: String,
    Rating: Number,
    Seasons: Number,
    Current_Season: Number,
    Price: Number
});

const SerieModel = mongoose.model('Serie', serieSchema);

class SeriesController {
    constructor() {
        // Lee las variables de entorno del archivo .env
        this.initMongoClient();
    }

    async initMongoClient() {
        const mongoUri = `mongodb://${process.env.MONGO_INITDB_ROOT_USERNAME}:${process.env.MONGO_INITDB_ROOT_PASSWORD}@${process.env.MONGO_CONTAINER_NAME}:${process.env.MONGO_PORT}/${process.env.MONGO_INITDB_DATABASE}?authSource=admin`;
        try {
            await mongoose.connect(mongoUri, { useUnifiedTopology: true });
            console.log('MongoDB Connected');
        } catch (error) {
            console.error('MongoDB Connection Error:', error);
        }
    }

    async guardarSerie(req, res) {
        try {
            // Verificar si los parámetros están presentes en la solicitud
            const { Title, Year, Genre, Rating, Seasons, Current_Season, Price } = req.body;
            if (!Title || !Year || !Genre || !Rating || !Seasons || !Current_Season || !Price) {
                return res.status(400).json({ error: 'Faltan parámetros en la solicitud' });
            }
    
            const serie = new SerieModel({ Title, Year, Genre, Rating, Seasons, Current_Season, Price });
            const result = await serie.save();
    
            res.status(201).json({ message: 'Serie guardada con éxito', serie: result });
        } catch (error) {
            console.error('Error al guardar la serie:', error);
            res.status(500).json({ error: 'Ocurrió un error al guardar la serie' });
        }
    }

    async obtenerSeriePorId(req, res) {
        try {
            const serieId = req.params.id;
            const serie = await SerieModel.findById(serieId);
            if (!serie) {
                return res.status(404).json({ error: 'Serie no encontrada' });
            }
            res.status(200).json({ serie });
        } catch (error) {
            console.error('Error al obtener la serie:', error);
            res.status(500).json({ error: 'Ocurrió un error al obtener la serie' });
        }
    }

    async actualizarSerie(req, res) {
        try {
            const serieId = req.params.id;
            const { Title, Year, Genre, Rating, Seasons, Current_Season, Price } = req.body;
            const updatedSerie = await SerieModel.findByIdAndUpdate(
                serieId,
                { Title, Year, Genre, Rating, Seasons, Current_Season, Price },
                { new: true }
            );
            if (!updatedSerie) {
                return res.status(404).json({ error: 'Serie no encontrada' });
            }
            res.status(200).json({ message: 'Serie actualizada con éxito', serie: updatedSerie });
        } catch (error) {
            console.error('Error al actualizar la serie:', error);
            res.status(500).json({ error: 'Ocurrió un error al actualizar la serie' });
        }
    }

    async eliminarSerie(req, res) {
        try {
            const serieId = req.params.id;
            const deletedSerie = await SerieModel.findByIdAndDelete(serieId);
            if (!deletedSerie) {
                return res.status(404).json({ error: 'Serie no encontrada' });
            }
            res.status(200).json({ message: 'Serie eliminada con éxito' });
        } catch (error) {
            console.error('Error al eliminar la serie:', error);
            res.status(500).json({ error: 'Ocurrió un error al eliminar la serie' });
        }
    }

    async listarSeries(req, res) {
        try {
            const series = await SerieModel.find();
            res.status(200).json({ series });
        } catch (error) {
            console.error('Error al listar las series:', error);
            res.status(500).json({ error: 'Ocurrió un error al listar las series' });
        }
    }

    async buscarSeriesPorGenero(req, res) {
        try {
            const genero = req.params.genero;
            const series = await SerieModel.find({ Genre: genero });
            if (series.length === 0) {
                return res.status(404).json({ error: 'No se encontraron series para el género especificado' });
            }
            res.status(200).json({ series });
        } catch (error) {
            console.error('Error al buscar las series por género:', error);
            res.status(500).json({ error: 'Ocurrió un error al buscar las series por género' });
        }
    }

    async mostrarSeriesConMasDeDosTemporadas(req, res) {
        try {
            const series = await SerieModel.find({ Seasons: { $gt: 2 } });
            if (series.length === 0) {
                return res.status(404).json({ error: 'No se encontraron series con más de 2 temporadas' });
            }
            res.status(200).json({ series });
        } catch (error) {
            console.error('Error al mostrar las series con más de 2 temporadas:', error);
            res.status(500).json({ error: 'Ocurrió un error al mostrar las series con más de 2 temporadas' });
        }
    }

    async encontrarSeriesPorTemporadaActual(req, res) {
        try {
            const temporadaActual = req.params.season;
    
            if (!temporadaActual) {
                return res.status(400).json({ error: 'Falta el parámetro current_season en la solicitud' });
            }
    
            const series = await SerieModel.find({ Current_Season: temporadaActual });
    
            if (series.length === 0) {
                return res.status(404).json({ error: 'No se encontraron series para la temporada especificada' });
            }
    
            res.status(200).json({ series });
        } catch (error) {
            console.error('Error al encontrar las series por temporada actual:', error);
            res.status(500).json({ error: 'Ocurrió un error al encontrar las series por temporada actual' });
        }
    }


    async buscarSeriesConPrecioInferior(req, res) {
        try {
            const series = await SerieModel.find({ Price: { $lt: 10 } });
    
            if (series.length === 0) {
                return res.status(404).json({ error: 'No se encontraron series con precio inferior a 10' });
            }
    
            res.status(200).json({ series });
        } catch (error) {
            console.error('Error al buscar las series con precio inferior a 10:', error);
            res.status(500).json({ error: 'Ocurrió un error al buscar las series con precio inferior a 10' });
        }
    }

    async buscarSeriesPorAño(req, res) {
        try {
            const anio = req.params.anio;
            const series = await SerieModel.find({ Year: anio });
    
            if (series.length === 0) {
                return res.status(404).json({ error: `No se encontraron series estrenadas en el año ${anio}` });
            }
    
            res.status(200).json({ series });
        } catch (error) {
            console.error('Error al buscar las series por año:', error);
            res.status(500).json({ error: 'Ocurrió un error al buscar las series por año' });
        }
    }

    async calcularPromedioPrecioSeries(req, res) {
        try {
            const result = await SerieModel.aggregate([
                {
                    $group: {
                        _id: null,
                        averagePrice: { $avg: "$Price" }
                    }
                }
            ]);
    
            if (result.length === 0) {
                return res.status(404).json({ error: 'No se encontraron series para calcular el promedio de precio' });
            }
    
            res.status(200).json({ averagePrice: result[0].averagePrice });
        } catch (error) {
            console.error('Error al calcular el promedio de precio de las series:', error);
            res.status(500).json({ error: 'Ocurrió un error al calcular el promedio de precio de las series' });
        }
    }

    async obtenerSeriesOrdenadasPorRating(req, res) {
        try {
            const series = await SerieModel.find().sort({ Rating: -1 });
            res.status(200).json({ series });
        } catch (error) {
            console.error('Error al obtener las series ordenadas por rating:', error);
            res.status(500).json({ error: 'Ocurrió un error al obtener las series ordenadas por rating' });
        }
    }

    async buscarSeriesPorPalabraClave(req, res) {
        try {
            const keyword = req.params.keyword;
            const regex = new RegExp(keyword, 'i'); // 'i' para hacer la búsqueda insensible a mayúsculas/minúsculas
            const series = await SerieModel.find({ Title: regex });
            res.status(200).json({ series });
        } catch (error) {
            console.error('Error al buscar las series por palabra clave:', error);
            res.status(500).json({ error: 'Ocurrió un error al buscar las series por palabra clave' });
        }
    }
    
}

module.exports = new SeriesController();
