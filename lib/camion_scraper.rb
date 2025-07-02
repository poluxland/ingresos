# app/services/camion_scraper.rb
require "httparty"
require "nokogiri"

class CamionScraper
  URL = "https://nexus.melon.cl:569/LlamadoCamiones/LlamadoLCA.aspx"

  # Ejecuta el scraping y retorna el número de filas procesadas
  def self.ejecutar
    # 1) Solicitud HTTP GET
    response = HTTParty.get(URL, verify: false)
    unless response.success?
      Rails.logger.error "[CamionScraper] HTTP request failed with code: #{response.code}"
      return 0
    end

    # 2) Parsear HTML
    doc = Nokogiri::HTML(response.body)

    # 3) Seleccionar filas de datos (descartar el header)
    filas = doc.css("table#GridView1 tr").select { |tr| tr.at_css("td") }

    # 4) Iterar y guardar cada registro
    filas.each do |row|
      cols = row.css("td").map { |td| td.text.strip }
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
    Rails.logger.error "[CamionScraper] Error: #{e.message}\n#{e.backtrace.first(5).join("\n")}"
    0
  end
end
