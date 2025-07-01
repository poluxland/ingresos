namespace :camiones do
  desc "Scrapea camiones en estado Llamado..."
  task scrape: :environment do
    CamionScraper.ejecutar
  end
end
