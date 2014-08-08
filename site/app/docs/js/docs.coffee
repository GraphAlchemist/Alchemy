$ ->
	$(".section-bar")
		.on 'click', () ->
			console.log "clicked!"
			$(@).siblings.removeClass("active")
			$(@).addClass("active")