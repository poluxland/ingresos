require "httparty"
require "nokogiri"

class CamionScraper
  URL = "https://nexus.melon.cl:569/LlamadoCamiones/LlamadoLCA.aspx"

  def self.ejecutar
    response = HTTParty.get(URL, verify: false)
    doc = Nokogiri::HTML(response.body)

    doc.css("table#GridView1 tbody tr").each do |row|
      columnas = row.css("td").map { |td| td.text.strip }
      next if columnas.size < 7
      next unless columnas[6].start_with?("Llamado")

      Camion.find_or_create_by(patente: columnas[1], estado: columnas[6]) do |camion|
        camion.posicion   = columnas[0]
        camion.tipo       = columnas[2]
        camion.lista      = columnas[3]
        camion.conductor  = columnas[4]
        camion.punto      = columnas[5]
        camion.scraped_at = Time.zone.now
      end
    end
  end
end
