if defined?(Footnotes) && Rails.env.development?
  #Footnotes.run! # first of all 
  # ... other init code
 # Footnotes::Filter.prefix = 'txmt://open/?url=file://%s&amp;line=%d&amp;column=%d'
end