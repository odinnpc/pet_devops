// server.js
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => res.send('Hello, Captain!'));
app.get('/health', (req, res) => res.status(200).send('ok'));

app.listen(port, () => console.log(`App listening on ${port}`));
