$(document).ready(function () {
    var quantitiy = 0;
    $('#button-plus').click(function (e) {
        e.preventDefault();
        var quantity = parseInt($('#quantity').val());
        $('#quantity').val(quantity + 1);
    });

    $('#button-minus').click(function (e) {
        e.preventDefault();
        var quantity = parseInt($('#quantity').val());
        if (quantity > 1) {
            $('#quantity').val(quantity - 1);
        }
    });
    $('#finalscreen').click(function (e) {
        addid = $('input[type=radio][name=address]:checked').attr('id');
        payid = $('input[type=radio][name=payment]:checked').attr('id');
        $('#orderNow').prop("href","/checkout.html?action=checkout&payid="+payid+"&addid="+addid);
    });
});