require "application_system_test_case"

class CamionsTest < ApplicationSystemTestCase
  setup do
    @camion = camions(:one)
  end

  test "visiting the index" do
    visit camions_url
    assert_selector "h1", text: "Camions"
  end

  test "should create camion" do
    visit camions_url
    click_on "New camion"

    fill_in "Conductor", with: @camion.conductor
    fill_in "Estado", with: @camion.estado
    fill_in "Lista", with: @camion.lista
    fill_in "Patente", with: @camion.patente
    fill_in "Posicion", with: @camion.posicion
    fill_in "Punto", with: @camion.punto
    fill_in "Scraped at", with: @camion.scraped_at
    fill_in "Tipo", with: @camion.tipo
    click_on "Create Camion"

    assert_text "Camion was successfully created"
    click_on "Back"
  end

  test "should update Camion" do
    visit camion_url(@camion)
    click_on "Edit this camion", match: :first

    fill_in "Conductor", with: @camion.conductor
    fill_in "Estado", with: @camion.estado
    fill_in "Lista", with: @camion.lista
    fill_in "Patente", with: @camion.patente
    fill_in "Posicion", with: @camion.posicion
    fill_in "Punto", with: @camion.punto
    fill_in "Scraped at", with: @camion.scraped_at.to_s
    fill_in "Tipo", with: @camion.tipo
    click_on "Update Camion"

    assert_text "Camion was successfully updated"
    click_on "Back"
  end

  test "should destroy Camion" do
    visit camion_url(@camion)
    click_on "Destroy this camion", match: :first

    assert_text "Camion was successfully destroyed"
  end
end
