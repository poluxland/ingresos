namespace :camiones do
  desc "Scrapea camiones en estado Llamado..."
  task scrape: :environment do
    require Rails.root.join("lib/camion_scraper")  # <-- esta línea es clave
    CamionScraper.ejecutar
    puts "Scrapeo de camiones completado."
  end
end
