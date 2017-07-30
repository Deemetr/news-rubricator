from flask import Flask
from flask import render_template, request, redirect, url_for
from classifier import get_prediction


app = Flask(__name__)
app.debug = True

@app.route('/')
def index():    
    return render_template('answer.html')

@app.route('/get_news_type', methods=['POST'])
def get_news_type():
    news_text = request.form['news-text']
    prediction = get_prediction(news_text)
    return render_template('answer.html', news_text=news_text, prediction=prediction)

def main():
    app.run()

if __name__ == '__main__':
    main()
