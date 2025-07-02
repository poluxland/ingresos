# app/services/camion_scraper.rb
require "httparty"
require "nokogiri"

class CamionScraper
  URL = "https://nexus.melon.cl:569/LlamadoCamiones/LlamadoLCA.aspx"
  MAX_RETRIES = 3

  # Ejecuta el scraping y retorna el número de filas procesadas
  def self.ejecutar
    response = fetch_with_retries
    return 0 unless response&.success?

    doc = Nokogiri::HTML(response.body)
    filas = doc.css("table#GridView1 tr").select { |tr| tr.at_css("td") }

    filas.each do |row|
      cols = row.css("td").map(&:text).map(&:strip)
      next if cols.size < 7

      camion = Camion.find_or_initialize_by(patente: cols[1])
      camion.assign_attributes(
        posicion:   cols[0],
        tipo:       cols[2],
        lista:      cols[3],
        conductor:  cols[4],
        punto:      cols[5],
        estado:     cols[6],
        scraped_at: Time.current
      )

      if camion.changed?
        camion.save!
        Rails.logger.info "[CamionScraper] Upserted camion: #{camion.patente} - Estado: #{camion.estado}"
      end
    end

    filas.size
  rescue StandardError => e
    Rails.logger.error "[CamionScraper] Unexpected error: #{e.class} - #{e.message}\n#{e.backtrace.first(5).join("\n")}"
    0
  end

  def self.fetch_with_retries
    tries = 0
    begin
      Rails.logger.info "[CamionScraper] Fetch attempt \#{tries + 1} to \#{URL}"
      HTTParty.get(
        URL,
        verify: false,
        open_timeout: 30,
        read_timeout: 60,
        follow_redirects: true
      )
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      tries += 1
      Rails.logger.warn "[CamionScraper] Timeout (#{e.class}): \#{e.message}. Retry \#{tries}/#{MAX_RETRIES}"
      retry if tries < MAX_RETRIES
      Rails.logger.error "[CamionScraper] All retries exhausted due to timeout."
      nil
    end
  end
end
