const express = require('express');
const app = express();
const LanguageDetect = require('languagedetect');
const lngDetector = new LanguageDetect();
lngDetector.setLanguageType("iso2");

app.use(express.json());

app.post('/language', (req, res) => {
    const content = req.body;
    let languages = [];

    content.forEach(text => {
        const language = lngDetector.detect(text.text,1);
        languages.push(language[0][0]);
    });

    data = {
        "languages":languages
    }

    res.json(data);
});

app.listen(5000, () => {
    console.log('Server running on port 5000');
});




