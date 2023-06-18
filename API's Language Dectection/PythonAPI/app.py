from flask import Flask,jsonify,request
from langdetect import detect

app = Flask(__name__)


@app.route('/language', methods=['GET', 'POST'])
def getLanguage():
    content = request.json
    languages = []

    for text in content:
        language = detect(text["text"])
        languages.append(language)

    data = {
        "languages": languages
    }
    return jsonify(data)


if __name__ == '__main__':
    app.run()




