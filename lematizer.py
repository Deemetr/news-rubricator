import MySQLdb


db = MySQLdb.connect(host="127.0.0.1", port=9306, charset='utf8', user='root', password='')
cursor = db.cursor()

def get_lemma_text(text):
    try:
        sql = "CALL KEYWORDS('%s', 'companies')" % str(text).replace("'", "\\\'")
        cursor.execute(sql)
        rows = cursor.fetchall()

        lemma_text = ' '.join([row[2] for row in rows])

        return lemma_text
    except Exception as e:
        return ''

