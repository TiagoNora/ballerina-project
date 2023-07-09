const axios = require('axios');
const proxy = require('express-http-proxy')
const express = require('express');
const app = express();
const PORT = 8080;
app.use(express.json());

app.listen(PORT, () => {
  console.log(`API gateway server is running on port ${PORT}`);
});


app.use('/sandwiches', proxy('http://localhost:8091'));
app.use('/ingredients', proxy('http://localhost:8090'));
app.use('/reviews', proxy('http://localhost:8095'));
app.use('/stores', proxy('http://localhost:8093'));
app.use('/orders', proxy('http://localhost:8094'));
app.use('/users', proxy('http://localhost:8092'));