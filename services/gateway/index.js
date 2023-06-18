const axios = require('axios');
const express = require('express');
const app = express();
const PORT = 8080;

app.listen(PORT, () => {
  console.log(`API gateway server is running on port ${PORT}`);
});

app.all('/sandwiches/*', (req, res) => {
  const serviceAUrl = `http://localhost:8091${req.originalUrl}`;

  if (req.method === 'GET' || req.method === 'DELETE') {
    axios({
      method: req.method,
      url: serviceAUrl,
      headers: req.headers
    })
      .then(response => {
        res.json(response.data);
      })
      .catch(error => {
        res.status(500).json({ error: 'An error occurred' });
      });
  } else {
    axios({
        method: req.method,
        url: serviceAUrl,
        headers: req.headers
      })
        .then(response => {
          res.json(response.data);
        })
        .catch(error => {
          res.status(500).json({ error: 'An error occurred' });
        });
  }
});

app.all('/ingredients/*', (req, res) => {
    const serviceAUrl = `http://localhost:8090${req.originalUrl}`;
  
    if (req.method === 'GET' || req.method === 'DELETE') {
      axios({
        method: req.method,
        url: serviceAUrl,
        headers: req.headers
      })
        .then(response => {
          res.json(response.data);
        })
        .catch(error => {
          res.status(500).json({ error: 'An error occurred' });
        });
    } else {
      axios({
          method: req.method,
          url: serviceAUrl,
          headers: req.headers
        })
          .then(response => {
            res.json(response.data);
          })
          .catch(error => {
            res.status(500).json({ error: 'An error occurred' });
          });
    }
});

app.all('/reviews/*', (req, res) => {
    const serviceAUrl = `http://localhost:8095${req.originalUrl}`;
  
    if (req.method === 'GET' || req.method === 'DELETE') {
      axios({
        method: req.method,
        url: serviceAUrl,
        headers: req.headers
      })
        .then(response => {
          res.json(response.data);
        })
        .catch(error => {
          res.status(500).json({ error: 'An error occurred' });
        });
    } else {
      axios({
          method: req.method,
          url: serviceAUrl,
          headers: req.headers
        })
          .then(response => {
            res.json(response.data);
          })
          .catch(error => {
            res.status(500).json({ error: 'An error occurred' });
          });
    }
});

app.all('/stores/*', (req, res) => {
    const serviceAUrl = `http://localhost:8093${req.originalUrl}`;
  
    if (req.method === 'GET' || req.method === 'DELETE') {
      axios({
        method: req.method,
        url: serviceAUrl,
        headers: req.headers
      })
        .then(response => {
          res.json(response.data);
        })
        .catch(error => {
          res.status(500).json({ error: 'An error occurred' });
        });
    } else {
      axios({
          method: req.method,
          url: serviceAUrl,
          headers: req.headers
        })
          .then(response => {
            res.json(response.data);
          })
          .catch(error => {
            res.status(500).json({ error: 'An error occurred' });
          });
    }
});

app.all('/orders/*', (req, res) => {
    const serviceAUrl = `http://localhost:8094${req.originalUrl}`;
  
    if (req.method === 'GET' || req.method === 'DELETE') {
      axios({
        method: req.method,
        url: serviceAUrl,
        headers: req.headers
      })
        .then(response => {
          res.json(response.data);
        })
        .catch(error => {
          res.status(500).json({ error: 'An error occurred' });
        });
    } else {
      axios({
          method: req.method,
          url: serviceAUrl,
          headers: req.headers
        })
          .then(response => {
            res.json(response.data);
          })
          .catch(error => {
            res.status(500).json({ error: 'An error occurred' });
          });
    }
});

app.all('/clients/*', (req, res) => {
    const serviceAUrl = `http://localhost:8092${req.originalUrl}`;
  
    if (req.method === 'GET' || req.method === 'DELETE') {
      axios({
        method: req.method,
        url: serviceAUrl,
        headers: req.headers
      })
        .then(response => {
          res.json(response.data);
        })
        .catch(error => {
          res.status(500).json({ error: 'An error occurred' });
        });
    } else {
      axios({
          method: req.method,
          url: serviceAUrl,
          headers: req.headers
        })
          .then(response => {
            res.json(response.data);
          })
          .catch(error => {
            res.status(500).json({ error: 'An error occurred' });
          });
    }
});