jQuery ->

	$("#arrow").click ->
		if $(this).hasClass "clicked"
			$(this).attr("src", "assets/up.png")
			$("#nav").css { height: "3em" }
			$(this).removeClass "clicked"
		else
			$(this).attr("src", "assets/down.png")
			$("#nav").css { height: "auto" }
			$(this).addClass "clicked"