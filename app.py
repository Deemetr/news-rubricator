from flask import Flask
from flask import render_template, request, redirect, url_for, jsonify
from classifier import get_prediction
from datetime import datetime


app = Flask(__name__)
app.debug = True

@app.route('/')
def index():    
    return render_template('index.html', now=datetime.now)

@app.route('/get_news_prediction', methods=['POST'])
def get_news_prediction():
    news_text = request.form['newsText']
    prediction = get_prediction(news_text)
    return jsonify({'prediction': prediction})

def main():
    app.run()

if __name__ == '__main__':
    main()
