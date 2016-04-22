class Hola::Translator
	def intialize(language)
		@language=language
	end
def hi 
	case @language
	when "spanish"
		"hola munda"
	else 
		"hello world"
	end
	end
end