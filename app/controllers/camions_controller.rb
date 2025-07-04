require "net/http"
class CamionsController < ApplicationController
  before_action :set_camion, only: %i[ show edit update destroy ]

  # GET /camions or /camions.json
  def index
    @camions = Camion.all
  end

  def check_port
    url = URI.parse("https://nexus.melon.cl:569/LlamadoCamiones/LlamadoLCA.aspx")

    begin
      Net::HTTP.start(url.host, url.port, use_ssl: true, open_timeout: 5) do |http|
        req = Net::HTTP::Get.new(url.request_uri)
        res = http.request(req)

        if res.code.to_i == 200
          flash[:notice] = "✅ Acceso exitoso al puerto 569 de nexus.melon.cl"
        else
          flash[:alert] = "⚠️ Se conectó, pero el servidor respondió con código #{res.code}"
        end
      end
    rescue => e
      flash[:alert] = "❌ No se pudo conectar a nexus.melon.cl:569 (#{e.class}: #{e.message})"
    end

    redirect_to camions_path
  end

  # POST /camions/scrape
  def scrape
    count = CamionScraper.ejecutar
    redirect_to camions_path, notice: "Scrape completado: #{count} filas procesadas."
  end

  # GET /camions/1 or /camions/1.json
  def show
  end

  # GET /camions/new
  def new
    @camion = Camion.new
  end

  # GET /camions/1/edit
  def edit
  end

  # POST /camions or /camions.json
  def create
    @camion = Camion.new(camion_params)

    respond_to do |format|
      if @camion.save
        format.html { redirect_to @camion, notice: "Camion was successfully created." }
        format.json { render :show, status: :created, location: @camion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @camion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /camions/1 or /camions/1.json
  def update
    respond_to do |format|
      if @camion.update(camion_params)
        format.html { redirect_to @camion, notice: "Camion was successfully updated." }
        format.json { render :show, status: :ok, location: @camion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @camion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /camions/1 or /camions/1.json
  def destroy
    @camion.destroy!

    respond_to do |format|
      format.html { redirect_to camions_path, status: :see_other, notice: "Camion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_camion
      @camion = Camion.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def camion_params
      params.expect(camion: [ :posicion, :patente, :tipo, :lista, :conductor, :punto, :estado, :scraped_at ])
    end
end
