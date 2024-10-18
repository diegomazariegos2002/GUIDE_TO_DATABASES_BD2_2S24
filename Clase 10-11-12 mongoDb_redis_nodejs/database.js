require('dotenv').config();
const { createClient } = require('redis');
const mongoose = require('mongoose');

class Database {
    static instance;

    constructor() {
        if (!Database.instance) {
            this.initRedisClient();
            this.initMongoClient();
            Database.instance = this;
        }
        return Database.instance;
    }

    initRedisClient() {
        const client = createClient({ url: `${process.env.REDIS_URL}${process.env.REDIS_CONTAINER_NAME}:${process.env.REDIS_PORT}` });
        this.redisConnectionPromise = client.connect();
        this.redisConnectionPromise.then(() => {
            console.log('Redis Client Connected');
            this.clientRedis = client;
        }).catch(err => {
            console.error('Redis Client Connection Error:', err);
        });
    }

    /**
     * Initializes the MongoDB client.
     * @returns {Promise<void>} A promise that resolves when the MongoDB client is connected.
     */
    initMongoClient() {
        const mongoUri = `mongodb://${process.env.MONGO_INITDB_ROOT_USERNAME}:${process.env.MONGO_INITDB_ROOT_PASSWORD}@${process.env.MONGO_CONTAINER_NAME}:${process.env.MONGO_PORT}/${process.env.MONGO_INITDB_DATABASE}?authSource=admin`;
        this.mongoConnectionPromise = mongoose.connect(mongoUri)
            .then(() => console.log('MongoDB Connected'))
            .catch(err => console.error('MongoDB Connection Error:', err));
    }

    /**
     * Returns the Redis client instance after it's connected.
     * @returns {RedisClientType} The connected Redis client.
     */
    getInstanceRedis() {
        return this.redisConnectionPromise.then(() => this.clientRedis);
    }

    /**
     * Returns the MongoDB connection promise.
     * @returns {Promise<void>} A promise that resolves when the MongoDB client is connected.
     */
    getMongoConnectionPromise() {
        return this.mongoConnectionPromise;
    }
}

const database = new Database();
module.exports = database;
