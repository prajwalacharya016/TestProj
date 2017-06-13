/**
 * Created by prajw on 5/2/2017.
 */
$(document).ready(function () {
    var getAppointments = function (myarg) {
        $("#output").empty();
        $.ajax({
            url: "getAppointments.pl"
            , data: {
                'search': myarg
            }
            , dataType: 'json'
            , success: function (responseJSON) {
                result = JSON.parse(responseJson);
                var mydat = data.test;
                var str = "";
                str = str + "<table style=\"width:100%\"> <tr> <th>Date</th> <th>Time</th> <th>Description</th> </tr>";
                $.each(result, function (index, appointment) {
                    var datetime = appointment.datetime.split(' ');
                    str = str + "<tr>";
                    str = str + "<td>" + datetime[0] + "</td>";
                    str = str + "<td>" + datetime[1] + "</td>";
                    str = str + "<td>" + appointment.description + "</td>";
                    str = str + "</tr>";
                });
                str = str + "</table>";
                $("#output").append(str);
            }
        });
    };
    $("#show").click(function () {
        $("#show").hide();
        $("#hide").show();
        $("#hide").css({
            display: "block"
        });
    });
    $("#cancel").click(function () {
        $("#show").show();
        $("#hide").hide();
    });
    $('#searchbutton').on('click', function (e) {
        var $link = $(e.target);
        e.preventDefault();
        if (!$link.data('lockedAt') || +new Date() - $link.data('lockedAt') > 300) {
            e.preventDefault();
            var value = $('#searchText').val();
            getAppointments(value);
        }
        $link.data('lockedAt', +new Date());
    });
    $('#searchText').keypress(function (event) {
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if (keycode == '13') {
            alert("Press With Mouse");
        }
        event.stopPropagation();
    });
    getAppointments("");
});