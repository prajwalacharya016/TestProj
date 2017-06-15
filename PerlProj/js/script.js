$(document).ready(function () {
    $("#appointmentForm").hide();
    $("#newButton").click(function () {
        $("#dashboard").hide();
        $("#appointmentForm").show();
    });
    $("#searchButton").click(function () {
        var searchData = $("#search").val();
        getAppointments(searchData);
    });
    $("#cancelButton").click(function () {
        $("#appointmentForm").hide();
        $("#dashboard").show();
    });
    $("#addButton").click(function (event) {
        var selectedDate = new Date($('#date').val() + " " + $('#time').val());
        var now = new Date();
        now.setHours(0, 0, 0, 0);
        if (selectedDate <= now) {
            alert("Please enter valid date");
            event.preventDefault();
        }
    });
    // gets appointment based on the searchData
    function getAppointments(searchData) {
        $.ajax({
            url: "getAppointments.pl"
            , data: {
                "search": searchData
            }
            , type: "GET"
            , success: function (responseJson) {
                // parse the result to JSON        
                result = JSON.parse(responseJson);
                //creates table
                $("#tableArea").text("");
                var $table = $("<table class='table table-hover'>").appendTo($("#tableArea"));
                $table.append($("<thead>"));
                $table.append($("<th>").text("Date"));
                $table.append($("<th>").text("Time"));
                $table.append($("<th>").text("Description"));
                $table.append($("</thead>"));
                $.each(result, function (index, appointment) {
                    var datetime = appointment.datetime.split(' ');
                    $table.append($("<tbody>"));
                    $("<tr class ='active'>").appendTo($table).append($("<td>").text(datetime[0])).append($("<td>").text(datetime[1])).append($("<td>").text(appointment.description));
                    $table.append($("</tbody>"));
                });
            }
        });
    }
});