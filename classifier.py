from sklearn.externals import joblib
from lematizer import get_lemma_text


clf = joblib.load('static/model/SVM_Rubrics_Model.pkl')
vectorizer = joblib.load('static/model/Vectorizer.pkl')

categories = dict([(1,"Политика"), (2,"Общество"), (3,"Экономика"), \
                (4,"Происшествия"), (5,"Спорт"), (6,"Наука"), \
                (7, "Культура"), (8, "Религия") ])

def get_prediction(text):
    lemma_text = get_lemma_text(text)
    tfidf = vectorizer.transform([lemma_text])
    prediction = clf.predict(tfidf)
    return categories[prediction[0]]
    