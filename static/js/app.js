$(document).ready(function(){

    $('#news-form').on('submit', function(event) {

        $.ajax({
            type : 'POST',
            url : '/get_news_prediction',
            data: { newsText: $('#news-text-area').val()}
        })
        .done(function(data) {

            if (data.prediction) {
                $('#result-holder').text(data.prediction).show();
            }            
        });

        event.preventDefault();

    });

});