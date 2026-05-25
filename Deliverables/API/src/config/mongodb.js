const mongoose = require('mongoose');
require('dotenv').config();

const connectMongoDB = async () => {
  try {
    const mongoUri = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/hospital_gerencia';
    await mongoose.connect(mongoUri);
    console.log('✅ 1/2 Conexión a MongoDB Exitosa (Área Gerencia)');
  } catch (error) {
    console.error('❌ Error conectando a MongoDB:', error.message);
    throw error;
  }
};

module.exports = connectMongoDB;