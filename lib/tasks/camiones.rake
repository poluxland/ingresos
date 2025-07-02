# lib/tasks/camiones.rake

# Tarea principal bajo namespace :camions
namespace :camions do
  desc "Scrapea y guarda el estado de los camiones"
  task scrape: :environment do
    count = CamionScraper.ejecutar
    puts "Scrapeo de camiones completado. Filas procesadas: #{count}"
  end
end

# Alias para llamar con rake camiones:scrape
namespace :camiones do
  desc "Alias para camions:scrape"
  task scrape: "camions:scrape"
end
